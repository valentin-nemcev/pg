<?php
/*
 Код вызова ссылок SetLinks.ru.
 Версия 3.2.1.
*/
require_once(dirname(__FILE__)."/slclient.php");

$sl = new SLClient();

$smarty->register_function("sl_get_links", "print_sl_links");

function print_sl_links($params)
{
    global $sl;
    
    if(isset($params['start']))
        $sl->SetCursorPosition($params['start']);
    if(isset($params['count']))
        return $sl->GetLinks($params['count']);
    else
        return $sl->GetLinks();        
}
?>
