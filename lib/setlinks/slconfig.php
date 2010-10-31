<?php
/*
 Код вызова ссылок SetLinks.ru.
 Версия 3.2.1
*/
define('SETLINKS_CODE_VERSION', '3.2.1');

class SLConfig {
    var $aliases = Array(); // алиасы сайтов. без www, в нижнем регистре. пример: Array("sitealias.ru" => "mainsite.ru", "sitealias2.ru" => "mainsite.ru")
    var $password = 'b2fdcfa04a1369ad286f37b6b341f2b0';  // Пароль
    var $encoding = 'UTF-8'; // Необходимая вам кодировка. (WINDOWS-1251, UTF-8, KOI8-R)
    var $server = 'show.setlinks.ru'; // сервер с которого берутся коды ссылок
    var $cachetimeout = 3600;  // Время обновления кэша в секундах
    var $errortimeout = 600;  // Период обновления кэша после ошибки в секундах
    var $cachedir = ''; // Директория куда будет сохраняться кэш(если пусто, то будет сохранен в папке со скриптом), в конце обязателен слэш "/"
    var $cachetype = 'FILE'; // тип кэша. (FILE, MYSQL)
    var $connecttype = '';  // тип соединения с сервером setlinks. (CURL - использовать библиотеку CURL, SOCKET - использовать сокеты, NONE - не соединяться с сервером, использовать данные кэша)
                            // если $connecttype пусто, то тип соединения определяется автоматом
    var $sockettimeout = 5; // Ожидание кода, секунд
    var $indexfile = '^/$'; // фильтр индексной страницы 

    var $use_safe_method = false; // защита от проверки на продажность ссылок, читать тут http://forum.setlinks.ru/showthread.php?p=1506#post1495
    var $allow_url_params = ""; // параметры которые могут появлятся в урле через пробел "mod id username"

    var $show_comment = true; // если true, то выводить коментарии всем, а не только индексаторам
    var $show_errors = true; // выводить или нет ошибки
    
    	// --- настройки для контекста ---
    	// Список тегов в которых не будут проставляться контекстные ссылки
    var $context_bad_tags = array( "a", "title", "head", "meta", "link", "h1", "h2", "thead", "xmp", "textarea", "select", "button", "script", "style", "label", "noscript", "noindex" );
    var $context_show_comments = false; // если true, то выводить коментарии всем, а не только индексаторам

    function __construct()
    {
      $this->cachedir = dirname(__FILE__).'/../../tmp/setlinks-cache/';
      if(!is_dir($this->cachedir)) mkdir($this->cachedir, 0777 ,true);
    }
}

?>
