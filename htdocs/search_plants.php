<html>
   <head>
   </head>
   <body>
      <h1>Open Farm</h1>
      <h2>Plant Database</h2>

      <nav>
         <ul>
            <li><a href="/plantrepository/index.html">Home</a></li>
            <li><a href="/plantrepository/insertdb.php">Add Plants</a></li>
            <li><a href="/plantrepository/search_plants.php"><strong>Search Plants</strong></a></li>
         </ul>
      </nav>
      
      <h2>Plant Repo Database Search:</h2>
      <form action="search_plants.php" method="POST">
         <input type="submit" value="Search">
         <input type="text" name="search_field" size=30 maxlength=255>
      </form>
      <?php
         // format table headers
         echo "<TABLE BORDER=1>
         <TR>
            <TH>id</TH>
            <TH>Given Name</TH>
            <TH>Plant Type</TH>
            <TH>Plant Variety</TH>
         </TR>";

         if ($_POST["search_field"] != null) {
            $keyword = $_POST["search_field"];
         
         
            // create plant repository connection
            $link = mysqli_connect("localhost","pnoble","","plantrepo")
            or die("Error: " . mysqli_error($link));

            // create SQL query select statement
            $sql = "SELECT * FROM plants ORDER BY given_name ASC";

            // execute SQL query -> get result
            $sql_result = $link->query($sql);

            // search for and format table rows based on keyword
            $i = 0; // results counter
            while ($row = mysqli_fetch_array($sql_result)) {
               $id = $row["id"];
               $given_name = $row["given_name"];
               $type = $row["plant_type"];
               $variety = $row["plant_var"];

               if ($keyword != null) {
                  if (stristr($given_name, $keyword) != FALSE) {
                     print_row($id,$given_name,$type,$variety);
                     $i++;
                  }
                  else if (stristr($type, $keyword) != FALSE) {
                     print_row($id,$given_name,$type,$variety);
                     $i++;
                  }
                  else if (stristr($variety, $keyword) != FALSE) {
                     print_row($id,$given_name,$type,$variety);
                     $i++;
                  }
               }
            }
            echo "</TABLE>";

            echo "
               <h3>$i Results for '$keyword'</h3>
                 ";
         }

         // function space
         function print_row($id,$given_name,$type,$variety) {
            echo "
               <TR>
                  <TD>$id</TD>
                  <TD><a href='/plantrepository/get_plantxml.php?given_name=$given_name'>$given_name</a></TD>
                  <TD>$type</TD>
                  <TD>$variety</TD>
               </TR>";
         }
         
         function array_search_i($str,$array){
            foreach($array as $key => $value) {
               if(stristr($str,$value)) return $key;
            }
            return false;
         }
      ?>
   </body>

   
</html>
