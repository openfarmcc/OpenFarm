<html>
   <head>
      <h1>Plant Repo Database Contents:</h1>
   </head>

   <body>
      <br>
      <h2>Table: "plants"</h2>

      <?php
         // create plant repository connection
         $conn = mysql_connect("localhost","pnoble","")
         or die(mysql_error());

         // select database
         $db = mysql_select_db("plantrepo", $conn) or die(mysql_error());

         // create SQL query select statement
         $sql = "SELECT id, given_name, plant_type, plant_var FROM plants ORDER BY given_name ASC";

         // execute SQL query -> get result
         $sql_result = mysql_query($sql, $conn) or die(mysql_error());

         // format table headers
         echo "<TABLE BORDER=1>
         <TR>
            <TH>id</TH>
            <TH>Given Name</TH>
            <TH>Plant Type</TH>
            <TH>Plant Variety</TH>
         </TR>";

         // get and format table rows
         while ($row = mysql_fetch_array($sql_result)) {
            $id = $row["id"];
            $given_name = $row["given_name"];
            $type = $row["plant_type"];
            $variety = $row["plant_var"];
            echo "
            <TR>
               <TD>$id</TD>
               <TD>$given_name</TD>
               <TD>$type</TD>
               <TD>$variety</TD>
            </TR>";
         }
         echo "</TABLE>";
      ?>
      
   </body>
   
</html>
