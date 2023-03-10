[string]$RemoteServer = 'W-MSSQL103.wd.clarkinc.io';[string]$LinkedServerName = 'mssql105' 
$RemoteConn = 'Data Source=' + $RemoteServer + ';Initial Catalog=master;Integrated Security=SSPI;'
$RemoteSqlConnection = New-Object System.Data.SqlClient.SqlConnection
$RemoteSqlConnection.ConnectionString = $RemoteConn
$RemoteSqlConnection.Open()
$SQL = 'SELECT * FROM [' + $LinkedServerName + '].master.sys.sysfiles;'
Write-Output $SQL
$ExecuteCommand = $RemoteSqlConnection.CreateCommand()
$ExecuteCommand.CommandText = $SQL
$ExecuteCommand.CommandTimeout = 30
$ExecuteCommand.ExecuteNonQuery()
$RemoteSqlConnection.Close()
