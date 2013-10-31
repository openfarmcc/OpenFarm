<html>
   <head>
      <h1>Add a plant to Plant Repo:</h1><br>
   </head>
   <body>
      <h2>Add in values and press submit</h2>
      <h3>General Information</h3>
      <form method="POST" action="plant_addrecord.php">
         <table cellspacing=5 cellpadding=5>
            <tr>
               <td valign=top><strong>Plant Name:</strong></td>
               <td valign=top><input type="text" name="given_name" size=30 maxlength=255></td>
            </tr>
            <tr>
               <td valign=top><strong>Plant Type:</strong></td>
               <td valign=top><input type="text" name="plant_type" size=30 maxlength=255></td>
            </tr>
            <tr>
               <td valign=top><strong>Plant Family:</strong></td>
               <td valign=top><input type="text" name="plant_var" size=30 maxlength=255></td>
            </tr>
            <!--<br><h3>Seeding Information</h3>
            <tr>
               <td valign=top><strong>-->
            <tr>
               <td align=center colspan=2><input type="submit"></td>
            </td>            
         </table>
      </form>
   </body>
</html>
