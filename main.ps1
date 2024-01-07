$file = Import-Csv "./empleados.csv"

foreach($element in $file){

    $var = $($element.grupo).substring(0,1)
    $admin = "smx"+$var+"01"
#    $admin =  $element.usuario | Select-String -Pattern "^smx+$($var)+01$"

        write-host "C:\smx2_datos\$($element.grupo)\$($element.usuario)"

        if (!(Test-Path -Path "C:\smx2_datos\$($element.grupo)\$($element.usuario)")) {
            <# Action to perform if the condition is false #>
            New-Item -Path "C:\smx2_datos\$($element.grupo)\$($element.usuario)" -ItemType Directory
            New-SmbShare -Name "$($element.usuario)$" -Path "C:\smx2_datos\$($element.grupo)\$($element.usuario)" -changeAccess $($element.usuario)
            Write-Host "Se creo la carpeta correctamente"
        }
        else {
            Grant-SmbShareAccess -Name "$($element.usuario)$" -AccountName $($element.usuario) -AccessRight Change -Force
        }


        write-host "C:\smx2_datos\$($element.grupo)\public_$($var)"

        if (!(Test-Path -Path "C:\smx2_datos\$($element.grupo)\public_$($var)")) {
            <# Action to perform if the condition is false #>
            New-Item  -Path "C:\smx2_datos\$($element.grupo)\public_$($var)" -ItemType Directory
            New-SmbShare -Name "public_$($var)" -Path "C:\smx2_datos\$($element.grupo)\public_$($var)" -ReadAccess $($element.grupo) -ChangeAccess $($admin)
        }
        else {
            Grant-SmbShareAccess -Name "public_$($var)" -AccountName $($element.grupo) -AccessRight Read -Force
            Grant-SmbShareAccess -Name "public_$($var)" -AccountName $admin -AccessRight Change -Force

        }

        if (!(Test-Path -Path "C:\smx2_datos\public_smx2")) {
            <# Action to perform if the condition is false #>
            New-Item -Path "C:\smx2_datos\public_smx2" -ItemType Directory
            New-SmbShare -Name "public_smx2" -Path "C:\smx2_datos\public_smx2" -changeAccess smx2 -ReadAccess $($element.grupo)
            Write-Host "Se creo la carpeta correctamente"
        }
        else {
            Grant-SmbShareAccess -Name "public_smx2" -AccountName $($element.grupo) -AccessRight Read -Force
        }

}