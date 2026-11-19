Get-ChildItem -Path . -Filter *.sql -File | ForEach-Object {
    $bytes = [System.IO.File]::ReadAllBytes($_.FullName)

    $encoding = switch ($true) {
        { $bytes.Length -ge 3 -and
          $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF } {
            "UTF-8 BOM"
            break
        }
        { $bytes.Length -ge 2 -and
          $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE } {
            "UTF-16 LE"
            break
        }
        { $bytes.Length -ge 2 -and
          $bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF } {
            "UTF-16 BE"
            break
        }
        default {
            try {
                $utf8 = [System.Text.UTF8Encoding]::new($false, $true)
                $null = $utf8.GetString($bytes)
                "UTF-8 (BOMなし)"
            }
            catch {
                "UTF-8ではない (要確認)"
            }
        }
    }

    [PSCustomObject]@{
        File     = $_.Name
        Encoding = $encoding
        Size     = $bytes.Length
    }
} | Format-Table -AutoSize
