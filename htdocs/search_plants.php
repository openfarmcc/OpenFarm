<html>
   <head>
   </head>
   <body>
      <h1>Plant Repo Database Search:</h1>
      <br>
      <?php
         $keyword = $_POST["search_field"];
         
         // create plant repository connection
         $link = mysqli_connect("localhost","pnoble","","plantrepo")
         or die("Error: " . mysqli_error($link));

         // create SQL query select statement
         $sql = "SELECT * FROM plants ORDER BY given_name ASC";

         // execute SQL query -> get result
         $sql_result = $link->query($sql);

         // format table headers
         echo "<TABLE BORDER=1>
         <TR>
            <TH>id</TH>
            <TH>Given Name</TH>
            <TH>Plant Type</TH>
            <TH>Plant Variety</TH>
         </TR>";

         // search for and format table rows based on keyword
         $i = 0; // results counter
         while ($row = mysqli_fetch_array($sql_result)) {
            $id = $row["id"];
            $given_name = $row["given_name"];
            $type = $row["plant_type"];
            $variety = $row["plant_var"];

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
         echo "</TABLE>";

         echo "
            <h3>$i Results for '$keyword'</h3>
              ";

         // function space
         function print_row($id,$given_name,$type,$variety) {
            echo "
               <TR>
                  <TD>$id</TD>
                  <TD>$given_name</TD>
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
