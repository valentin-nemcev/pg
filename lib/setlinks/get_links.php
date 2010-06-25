<?

$_SERVER = array('HTTP_HOST' => $argv[1],
		 'REQUEST_URI' => $argv[2],
		 'REMOTE_ADDR' => $argv[3]);

require_once(dirname(__FILE__)."/slclient.php");
$sl = new SLClient();	
echo $sl->GetLinks(); 

