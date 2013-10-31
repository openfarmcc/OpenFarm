OpenFarm
========

OpenFarm (OpenFarm.cc) is a free and open database for farming and gardening knowledge. One might think of it as the Wikipedia or Freebase for growing plants. The data is crowdsourced and includes all of the necessary paramaters for a machine or human to successfully grow a plant, ie: seed spacing and depth, water regimen, recommended soil composition and companion plants, sun/shade requirements, etc.

This project is closely related to the FarmBot project but also distinctly separate. OpenFarm is a standalone database that will simply provide data to other applications. For FarmBot, OpenFarm will supply the default settings to grow a plant when a user selects it in the graphical FarmBot frontend. In addition, FarmBot users will be able to modify the settings and be able to check a box to contribute their modifications back to OpenFarm.

OpenFarm will also have a web frontend of its own to allow Joe Gardener to access the data and make contributions.

Examples of other applications using OpenFarm: a mobile application for home gardeners, Google providing "One Box" answers to search queries such as "How do I grow tomatoes", Wolfram Alpha displaying the data for "growng tomatoes" which is also showed to users asking Siri on iDevices, etc.


** Developer Docs **

	* I will make the install directions more clear and concise in the near future!
	
To run/contribute your own instance of the OpenFarm web repository, you will have to set up your own server and database. 
Currently the website is written in HTML and PHP, so I recommend using XAMPP for the Apache2. Of course, if you understand the Apache2 development API well, you can manually install the PHP and MySQL dependencies.
Set up for the MySQL database will involve creating the necessary table and columns used in the PHP code... see the dabase_structure.png in the setup notes folder.

By the way, I am new to web development other than straight up front end design in Actionscript3/Flex, so if anyone has suggestions on how to better set up this directory, or any advice at all, please let me know at pnob32@gmail.com =)