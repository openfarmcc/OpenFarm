<?php
   header("Content-Type: application/octet-stream");
   header("Content-Disposition: attachment; filename=thexmlfile.xml");
   readfile("thexmlfile.xml");
?>
