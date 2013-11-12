<html>

   <head>
      <h2>Hello, <?php echo $_POST["username"]; ?></h2><br>
   </head>
   <body>
      email: <?php echo $_POST["userEmail"]; ?>
      <table border="1">
         <tr>
            <th>Plant Name</th>
            <th>Seeding Info</th>
            <th>Growing Info</th>
         </tr>
         <tr>
            <td><?php echo $_POST["pName"]; ?></td>
            <td><?php echo $_POST["seedDepth"]; ?></td>
            <td><?php echo $_POST["growTime"]; ?></td>
         <tr>
      </table>
   </body>
</html>
