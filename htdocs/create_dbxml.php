<html>
   <head>
   </head>
   <body>
      <?php
         // create plant repository connection
         $conn = mysql_connect("localhost","pnoble","")
         or die(mysql_error());

         // select database
         $db = mysql_select_db("plantrepo", $conn) or die(mysql_error());

         // create SQL query select statement
         $sql = "SELECT * FROM plants ORDER BY given_name ASC";

         // execute SQL query -> get result
         //$sql_result = $link->query($sql);
         $run = mysql_query($sql, $conn);

         if (mysql_num_rows($run)) {
            $doc = new DOMDocument('1.0');
            $doc -> formatOutput = true;
            $doc -> preserveWhiteSpace = true;

            $root = $doc->createElement('data');
            $doc -> appendChild($root);            
   
            // step through database

            while (($fetch = mysql_fetch_assoc($run)) !== false) {
               $node = $doc -> createElement('plant');
               $root -> appendChild($node);

               foreach ($fetch as $key => $value) {
                  createNodes($key, $value, $doc, $node);                  
               }
            }
            
            $doc->save("thexmlfile.xml");
         }

         function createNodes($key, $value, $doc, $node) {
            $key = $doc -> createElement($key);
            $node -> appendChild($key);
            $key -> appendChild($doc->createTextNode($value));
         }
      ?>
      <a href="/plantrepository/thexmlfile.xml">sample file</a>
   </body>
</html>
