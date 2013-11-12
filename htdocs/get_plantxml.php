<?php

   $plant_name = $_GET['given_name'];
   // create plant repository connection
   $conn = mysql_connect("localhost","pnoble","")
   or die(mysql_error());

   // select database
   $db = mysql_select_db("plantrepo", $conn) or die(mysql_error());

   // create SQL query select statement
   $sql = "SELECT * FROM plants ORDER BY given_name ASC";

   // execute SQL query -> get result
   $run = mysql_query($sql, $conn);

   if (mysql_num_rows($run)) {
      // step through detabase
      while (($fetch = mysql_fetch_assoc($run)) !== false) {
         //check for correct file to download
         $id = $fetch["id"];
         $given_name = $fetch["given_name"];
         $type = $fetch["plant_type"];
         $variety = $fetch["plant_var"];

         if (stristr($given_name, $plant_name) != FALSE) {
            $doc = new DOMDocument('1.0');
            $doc -> formatOutput = true;
            $doc -> preserveWhiteSpace = true;

            $root = $doc->createElement('data');
            $doc -> appendChild($root);

            $node = $doc -> createElement('plant');
            $root -> appendChild($node);

            foreach ($fetch as $key => $value) {
               createNodes($key, $value, $doc, $node);                  
            }

            $doc->save($plant_name.".xml");
         }
      }
   }

   function createNodes($key, $value, $doc, $node) {
      $key = $doc -> createElement($key);
      $node -> appendChild($key);
      $key -> appendChild($doc->createTextNode($value));
   }

   header("Content-Type: application/octet-stream");
   header("Content-Disposition: attachment; filename=".$plant_name.".xml");
   readfile($plant_name.".xml");
?>
