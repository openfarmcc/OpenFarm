<?php
   if ((!$_POST["given_name"])||(!$_POST["plant_type"])||(!$_POST["plant_var"])) {
      header("Location: http://127.0.0.1/plantrepository/insertdb.php");
      exit;
   }
?>

<html>
   <head>
   </head>
   <body>
      <h1>Adding Plant to Database...</h1>
      <?php
         // establish connection
         $conn = mysql_connect("localhost","pnoble","") or die(mysql_error());
         // select database
         $db = mysql_select_db("plantrepo", $conn) or die(mysql_error());
         // create SQL query select statement
         $sql_query = "SELECT id, given_name, plant_type, plant_var FROM plants ORDER BY given_name ASC";
         // execute SQL query -> get result
         $sql_result = mysql_query($sql_query, $conn) or die(mysql_error());
         // step through current contents
         $i = 0;
         while ($row = mysql_fetch_array($sql_result)) {
            $i++;
         }
         $i++;
         // insert _POST array
         $sql_insert = "INSERT INTO plants (id, given_name, plant_type, plant_var) VALUES ('$i','$_POST[given_name]','$_POST[plant_type]','$_POST[plant_var]')";
         // execute SQL insert command and get result
         $sql_result = mysql_query($sql_insert,$conn) or die(mysql_error());

         // redirect back 
         header("Location: http://127.0.0.1/plantrepository/insertdb.php");
         exit;
      ?>
   </body>
</html> 
