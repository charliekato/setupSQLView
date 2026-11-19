using Microsoft.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Security;

// 接続文字列を保持
string connectionStr = "";

// SQL ディレクトリ
const string SQL_DIR = "./sql";

// Server 名を入力
Console.Write("SQL Server [localhost]: ");
string server = Console.ReadLine()?.Trim() ?? "";

if (string.IsNullOrEmpty(server))
    server = "localhost";

// 接続文字列を作成
var builder = new SqlConnectionStringBuilder
{
    DataSource = server,
    InitialCatalog = "Sw",
    TrustServerCertificate = true
};

if (server.Equals("localhost", StringComparison.OrdinalIgnoreCase)
    || server.Equals(".", StringComparison.OrdinalIgnoreCase))
{
    // Windows 認証
    builder.IntegratedSecurity = true;
}
else
{
    // SQL Server 認証
    Console.Write("User ID: ");
    builder.UserID = Console.ReadLine() ?? "";

    Console.Write("Password: ");
    builder.Password = ReadPassword();

    builder.IntegratedSecurity = false;
}

connectionStr = builder.ConnectionString;

// 接続確認
try
{
    using var conn = new SqlConnection(connectionStr);
    conn.Open();
    Console.WriteLine("Connected successfully.\n");
}
catch (Exception ex)
{
    Console.WriteLine($"Connection failed: {ex.Message}");
    return;
}

// SQL ファイル実行
string listFile = Path.Combine(SQL_DIR, "sqls.list");

foreach (string line in File.ReadLines(listFile))
{
    string filename = line.Trim();

    if (filename.Length == 0 || filename.StartsWith('#'))
        continue;

    string sqlfile = Path.Combine(SQL_DIR, filename);

    ExeSql(sqlfile);
}

Console.WriteLine("\nAll SQL files executed.");


void ExeSql(string sqlfile)
{
    Console.WriteLine($"Executing: {sqlfile}");

    string sql = File.ReadAllText(sqlfile);

    var batches = Regex.Split(
        sql,
        @"^\s*GO\s*(?:--.*)?$",
        RegexOptions.Multiline | RegexOptions.IgnoreCase
    );

    using var conn = new SqlConnection(connectionStr);
    conn.Open();

    foreach (var batch in batches)
    {
        if (string.IsNullOrWhiteSpace(batch))
            continue;

        using var cmd = new SqlCommand(batch, conn);
        cmd.ExecuteNonQuery();
    }
}


// パスワードを画面に表示せず入力
string ReadPassword()
{
    var password = new System.Text.StringBuilder();

    while (true)
    {
        var key = Console.ReadKey(intercept: true);

        if (key.Key == ConsoleKey.Enter)
            break;

        if (key.Key == ConsoleKey.Backspace)
        {
            if (password.Length > 0)
                password.Length--;

            continue;
        }

        if (!char.IsControl(key.KeyChar))
            password.Append(key.KeyChar);
    }

    Console.WriteLine();
    return password.ToString();
}
