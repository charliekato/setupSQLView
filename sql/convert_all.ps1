$cp932 = [System.Text.Encoding]::GetEncoding(932)
$utf8  = [System.Text.UTF8Encoding]::new($false)

Get-ChildItem -Path . -Filter *.sql -File | ForEach-Object {

    $file = $_
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)

    # UTF-8 BOM がある場合は対象外
    if ($bytes.Length -ge 3 -and
        $bytes[0] -eq 0xEF -and
        $bytes[1] -eq 0xBB -and
        $bytes[2] -eq 0xBF) {
        Write-Host "SKIP  $($file.Name) (UTF-8 BOM)"
        return
    }

    # UTF-8 として正常に読めるか確認
    try {
        $strictUtf8 = [System.Text.UTF8Encoding]::new($false, $true)
        $null = $strictUtf8.GetString($bytes)

        Write-Host "SKIP  $($file.Name) (UTF-8)"
        return
    }
    catch {
        # UTF-8 でなければ CP932 として変換
    }

    # バックアップ
    Copy-Item $file.FullName "$($file.FullName).bak"

    # CP932 → UTF-8
    $text = $cp932.GetString($bytes)
    [System.IO.File]::WriteAllText(
        $file.FullName,
        $text,
        $utf8
    )

    Write-Host "CONVERT $($file.Name) (CP932 -> UTF-8)"
}
