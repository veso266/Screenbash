<?php
/**
 * Sharex custom uploader
 *
 * This script is used to upload a custom image, text, or file using the program sharex (https://code.google.com/p/sharex/)
 *
 * PHP version 5
 *
 * LICENSE: This file is licensed under the DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE, Version 2
 *  Everyone is permitted to copy and distribute verbatim or modified 
 *  copies of this license document, and changing it is allowed as long 
 *  as the name is changed. 
 *
 *
 * @category   Uploader
 * @author     GunfighterJ <gunfighterj@gmail.com>
 * @copyright  2013 GunfighterJ
 * @license    Do what the fuck you want to public license (http://www.wtfpl.net)
 * @version    1.0
 * @link       http://gunfighterj.com
 */

/** NOTES
*  This script was created by GunfighterJ (http://gunfighterj.com)
*  You are free to use and distribute this script under the wtfpl; however, if you do distribute it as your own without modifying it, I will be sad.
*
*  This script was designed to be used with sharex (https://code.google.com/p/sharex/) but can be easily modified for other upload systems
*
*
*  INSTALLATION/USAGE:
*  To use it, you must create a custom uploader with a Request type of "POST", and file form name of "file"
*  
*  You must also provide a POST argument of "key" that contains the secret key as defined below (default is SECRET_KEY)
*
*  Optionally you can define a POST parameter, "length" which allows you to change the length of the randomly generated URL
*
*  Options are defined below and are pretty straight forward. You are free to modify this script    
*/


//CONFIG ----------------------------------

//Directory to which files will be uploaded
$directory = "/home/user/imagefolder/";

//URL which will be displayed after upload (URL will have the file name appended)
$url = "http://example.com/";

//Secret key used to authenticate with the script so others don't hijack your uploads.
$key = "secret";

//Array of extensions to hide. If the extension is not in this array, it will be displayed in the final output. A .htaccess file with mod_rewrite (or equivilent for other web servers) can be used to serve the file without the extension
$hide_extension = array("jpg", "png", "gif", "txt", "log", "txt");

//Array of extensions to generate a random key code for, if the extension is not in here, the file's name will be used. This can be used to shorten the URL's if your uploads have long names
$generate_url = array("png", "jpg", "gif", "log", "txt", "webm", "mp4", "avi");

//Number of characters to be shown when a random file name is generated. Alternatively, if a POST variable of "length" is set, that will be used instead.
$url_length = 5;

//END CONFIG ------------------------------

if ($_POST['key'] !== $key)
{
    header("HTTP/1.0 403 Forbidden");
    die();
}

if(!isset($_FILES['file']))
{
    fail();
}

if (isset($_POST['length']))
{
    if (is_int($_POST['length'])
    {
        $url_length = $_POST['length'];
    }
    else
    {
        $url_length = intval($_POST['length']);
    }
}

$file = $_FILES['file'];
$name = $file['name'];
$parts = explode(".", $name);
$extension = end($parts);

$final_name = $name;

if (in_array($extension, $generate_url))
{
    $final_name = generateFileName($extension);

    if ($final_name == null)
        fail();
}

move_uploaded_file($file['tmp_name'], $directory.$final_name.".".$extension);

if (!in_array($extension, $hide_extension) && in_array($extension, $generate_url))
{
    $final_name .= ".$extension";
}

echo $url.$final_name;

function fail()
{
    header("HTTP/1.0 415 Unsupported Media Type");
    die();
}

function generateRandomString($length = 8)
{
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-~';
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, strlen($characters) - 1)];
    }
    return $randomString;
}

function generateFileName($extension)
{
    global $directory, $url_length;

    $name = generateRandomString($url_length);

    $count = 0;
    while (file_exists($directory.$name.".$extension"))
    {
        $name = generateRandomString($url_length);
        $count++;

        if ($count > 10)
            return null;        
    }
    return $name;
}

?>
