# PowerApps - Reading no-SQL Data from CosmosDB
This is a lab to walk users through how to create a PowerApp to read unstructured/no-SQL data from Azure Cosmos DB via Flow.

This tutorial is based on the assumption that you already have an <a href="http://www.mxchip.com/az3166" target="_blank">MX Chip</a> connected to an <a href="https://docs.microsoft.com/en-us/azure/iot-hub/about-iot-hub" target="_blank">IoT Hub</a> and <a href="https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction" target="_blank">Stream Analytics</a> is processing the messages and writing this information to a SQL API based <a href="https://docs.microsoft.com/en-us/azure/cosmos-db/introduction" target="_blank">Cosmos DB</a>.  We will then use <a href="https://flow.microsoft.com" target="_blank">Microsoft Flow</a> to process and structure that no-SQL data stored in the Cosmos DB json documents and pass it to <a href="https://powerapps.microsoft.com" target="_blank">Power Apps</a> in a structured manner so it can process and render the data in the Power Apps GUI.  

Below is a representation of the overall architecture of this solution.  For this lab, we will just focus on the Flow and PowerApp component to pull from a document directory in Cosmos DB.  The stream analytics query used for this sample is included in the files firectory of this repository.

![Alt text](/imgs/Architecture.gif?raw=true "Overall Architecture")

For this walkthrough, as a reference I have an Azure Cosmos Database using the SQL API that is housing json documents in a collection called <b> Telemetry</b> in a database called <b>IoT</b>...

![Alt text](/imgs/cosmos.gif?raw=true "Cosmos DB")

# Create the Flow
Our first step is to go into Flow and create a flow to read from Cosmos DB supply a structured data set to PowerApps.

<ol>
  <li>Go to https://flow.microsoft.com/ and log in.</li>
  <li>Click on <b>My Flows</b> on the left navigation bar and select <b>New</b> along the top and select <b>Create from blank</b>.</li>
  <li>You will then be presented with the screen below.  Click <b>Create from blank</b> one more time.<br>

![Alt text](/imgs/createfromblank.gif?raw=true "Cosmos DB") 
  </li>
  <li>Under <b>Search connector and triggers</b>, search for <b>PowerApps</b></li>
  <li>Under <b>Triggers</b> select <b>PowerApps</b><br>

![Alt text](/imgs/SearchPowerApps.gif?raw=true) 
  </li>
  <li> Click <b>+ New step</b> and search for <b>initial</b></li>
  <li>Under <b>Actions</b> select <b>Initialize variable</b><br>

![Alt text](/imgs/Initializevariable.gif?raw=true) 
  </li>
  <li>Under the Initialize variable control, fill in the following</li>
    <ol>
        <li>Name = CosmosQuery</li>
        <li>Type = String</li>
        <li>Value = Initializevariable_Value.<br>NOTE: This is selected by clicking on the Value field box and under Dynamic content select <b>See more</b> next to the Power Apps heading.  Double click <b>Ask in PowerApps</b> control and it should populate the Value field. When finished it should look like below</li>
        <br>
    </ol>
        
![Alt text](/imgs/Initializevariable_Value.gif?raw=true) 
  <li> Click <b>+ New step</b> and search for <b>Cosmos</b></li>
  <li>Under <b>Actions</b> select <b>Query documents</b></li>
  <li>Under the Initialize variable control, fill in the following...</li>
    <ol>
        <li>Database ID = [select your database name here]</li>
        <li>Collection ID = [select your collection name here]</li>
        <li>query = [add your relavent SQL statement here]<br>
        You can use the <a href= "https://github.com/jcbendernh/PowerAppsCosmosDB/blob/master/files/CosmosDBQuery.sql" target="_blank">CosmosQueryDB.sql</a> file in the files directory of this repository for reference.  You will need to add the <b>CosmosQuery variable</b>.  See the screenshot below for reference.<br> NOTE:  Do not use <b>select *</b> as the intent of this exercise is to provide a structured set of data to the PowerApp and <b>select *</b> is not structured when querying no-SQL data stores.</li>
        <li>Leave the partition key value blank</li>
        <br>
    </ol>

![Alt text](/imgs/Querydocuments.gif?raw=true) 
  <li> Click <b>+ New step</b> and search for <b>response</b></li>
  <li>Under <b>Actions</b> select <b>Response</b><br>

![Alt text](/imgs/response.gif?raw=true) 

<li>Body = Documents<br>NOTE: This is selected by clicking on the Body field box and under Dynamic content double click the <b>Documents</b> control under the Query Documents heading and it should populate the Body field. When finished it should look like below</li>
<li>Expand <b>Show advanced options</b> to expose the <b>Response Body JSON Schema</b> field.  You will use this field to define your JSON schema.  The best way to do so is to copy the json from one of your json documents in your Cosmos DB collection and then using the use sample payload to generate schema selection, paste your selection into the new window and click Done.  For reference, there is also a sample of this JSON format in the <a href="https://github.com/jcbendernh/PowerAppsCosmosDB/blob/master/files/JSONpayload.json" target="_blank">JSONpayload.json</a> file in the files directory.</li>

![Alt text](/imgs/JSONpayload.gif?raw=true)

Here is a reference screenshot of the Response control...<br>

![Alt text](/imgs/responsescreenshot.gif?raw=true)

  <li>Next name your PowerApp and Save it</li>
  <li>We can now test it using a deviceid value from one of our json documents in our Cosmos DB collection.  To do so, click the <b>Test</b> button and select <b>I'll perform the trigger action</b> and click <b>Test</b>.</li>
  <li>Paste the deviceid value from one of the json documents in your Cosmos DB collection into the <b>Initializevariable_Value field</b> and click <b>Run flow</b>.  For reference, I am using the deviceid from the <a href="https://github.com/jcbendernh/PowerAppsCosmosDB/blob/master/files/JSONpayload.json" target="_blank">JSONpayload.json</a> file in the files directory.  You can then view the <b>run activity</b> to see if your test was successful.  Within the run activity, if all components have passed, you can see the results of the Cosmos DB query by expanding the <b>Response</b> component and viewing the <b>Body</b> of the <b>OUTPUTS</b> section.</li>
</ol>

# Creating the PowerApp
Now that we have completed building out the Flow, let's use it to display the data within the PowerApp.  For this example, we will showcase a simple example creating a Canvas app that displays a listing of records based on a text search box.  At the end of this section, I will also provide some guidance on how to create a drill though screen to display detailed information of each reading and also how to create a drop down box to allow the user to display a fixed listing of registered devices.

<ol start="19">
  <li>Go to https://web.powerapps.com and log in.</li>
  <li>We are going to create a blank canvas app from scratch.  To do so, select <b>Canvas app from blank</b>.  You are now in the PowerApp designer with a blank canvas app displayed.  First, we will add a text input box to search on, in the menu bar, go to <b>Insert | Text drop down | Text input</b>...

  ![Alt text](/imgs/textinput.gif?raw=true)
  </li>
  <li>Next click the <b>Button</b> button from the toolbar to insert the button control onto the canvas.  Move it below the text input field like so...

  ![Alt text](/imgs/buttoncontrol.gif?raw=true)
  </li>
  <li>Next click on the button control to highlight it.  You should now see it's properties to the right.  In the menu bar, click <b>Action</b> and select <b>Flows</b>.  We need to associate the flow that we just created with the button.  To do so select the Flow from the list and when completed it should be under the <b>Flows associated with 'Button1'</b> section. We can also see it in the formula bar above...
  
  ![Alt text](/imgs/buttonactionflow.gif?raw=true)
  </li>
  <li>Now we need to modify the formula from <b>[Your flow].Run(</b> to <b>ClearCollect(queryResults,[Your flow].Run(TextInput1.Text))</b> like the example below...
  
  ![Alt text](/imgs/buttonformula.gif?raw=true)
  <br>
  This will trigger the search based on the value in the text box.
  </li>
  <li>Next we will insert a Gallery to return the result set.  On the Menu bar, select <b>Insert | Gallery drop down | Vertical</b>...
  
  ![Alt text](/imgs/insertgallery.gif?raw=true)
  <br>
  Note:  We will not use the image control in the gallery, only the 2 text fields to return results 
   </li>
  <li>Move the gallery so it is below the button.</li>
  <li>In the Gallery properties window, click the <b>Advanced</b> tab and set Items = <b>queryResults</b></li>
  <li>In the Data window, select 2 valid fields from your result set in the <b>Subtitle1</b> and <b>Title1</b> fields...

  ![Alt text](/imgs/galleryproperties.gif?raw=true)
  </li>
  <li>Next, let's Preview the app, click on the Preview button in the upper right...
  
  ![Alt text](/imgs/previewapp.gif?raw=true)
  </li>
  <li>Next type a valid device in the field and click the Button.  You should get a valid result set in your gallery...
  
  ![Alt text](/imgs/preview.gif?raw=true)
  
  </li>
  <li><B>Congratulations</b>.  You retrieved Cosmos DB data within a Power App using Flow.  Next let's exit out of the preview and save our Power App under <b>File | Save</b>.  You can now clean up your screen in the Power App as you see fit.  If you would like to try some of the extra credit sections below, be my guest.</li>  
</ol>

# Creating the Detail View within the Power App
Now that we have the list view in the PowerApp, we would also like to be able to click on a record and have it drill into a more detailed view.  To do so, we will first need to create another Flow to give us the specific record information.  After that is created, we can add a Detail Screen to our PowerApp and add the proper controls to populate that screen and enable navigation between the two.  

<ol start="31">
  <li>Log into https://flow.microsoft.com/ and click on <b>My flows</b> in the left navigation bar and hover over your flow in the listing and click the <b>elipsis button</b> and select <b>Save As</b> and save it with the same name appended with "-ID"...

  ![Alt text](/imgs/flowsaveas.gif?raw=true)
  </li>
  <li>Next we will edit our flow.  Only one modification is needed, we are going to change the </b>query</b> in the <b>Query documents</b> step to pull only one record.  You can use the <a href ="https://github.com/jcbendernh/PowerAppsCosmosDB/blob/master/files/CosmosDBQuery-ID.sql" parent="_blank">CosmosDBQuery-ID.sql</a> file in the files directory for a template.  Once completed click <b>Save</b> to save your Flow. Make sure to <b>turn on your Flow</b> as well</li>
  <li>Now we can go into our PowerApp we just created and in the menu bar, go to <b>Insert | New Screen | Blank</b>...

  ![Alt text](/imgs/insertblankscreen.gif?raw=true)
  </li>
  <li>Lets rename our screens so to <b>BrowseScreen</b> and <b>DetailScreen</b>.  Highlight the screen control and click on the elipsis button to rename.  When finished, it should like...

  ![Alt text](/imgs/renamescreens.gif?raw=true)
  </li>
  <li>On the BrowseScreen, highlight the arrow control on the form and click on the Advanced Tab.  Add the following to OnSelect...  <b>Navigate(DetailScreen, ScreenTransition.Cover,{id:ThisItem.id} )</b>...</b> and associate the flow you just created to the DetailScreen.  In the formula bar above change your formula to <b>ClearCollect(queryResultsID,'[Your Flow name here]'.Run(id))</b>...

  ![Alt text](/imgs/detailscreenonvisible.gif?raw=true)

  </li>
  <li>Make sure you are on the <b>DetailScreen</b>.  In the menu bar, go to <b>Insert | Gallery | Blank flexible height</b>...
  
  ![Alt text](/imgs/insertblankgallery.gif?raw=true)
  </li>
  
  <li>Click the <b>Advanced tab</b> on the Gallery and under <b>Items</b>, add <b>queryResultsID</b>...
  
  ![Alt text](/imgs/gallery2items.gif?raw=true)
  </li>

  <li>With the Gallery highlighed, first click <b>Add an item from the Insert Tab</b> within the gallery control on the form and on the menu bar select <b>Insert | Text | Label</b>.  It should add the text control to the Gallery.  You can repeat this step as many times as needed to add the proper fields to your DetailScreen Gallery.</li>

  <li>Highlight your text field and under the <b>Advanced</b> tab, make sure that <b>OnSelect = Select(Parent)</b>.  If not, you did not add the label within the Gallery and it is floating independently on the form.  Delete the field and repeat the step above again.</li>

  <li>Change the <b>text</b> control on your label to <b>ThisItem.[Your desired field]</b>...

  ![Alt text](/imgs/galleryitemtext.gif?raw=true)
  </li>

  <li>Repeat the step above for each field you have in the gallery
  <br>
  NOTE:  If you want to combine the field and label together, you can use the concatenate function.  Here is an example...  <b>Concatenate("Humidity:  ",Text(Round(ThisItem.humidity,2)))</b><br>
  For more information on PowerApp formulas, check out <a href="https://docs.microsoft.com/en-us/powerapps/maker/canvas-apps/formula-reference" target="_blank">Formula reference for PowerApps</a>.
  </li>
  <li>Last of all, we need to add a back button to the top of the DetailScreen.  Click on the DetailScreen <b>outside of the gallery</b> and within the Menu bar select <b>Insert | Icons | Back icon</b>...
  
  ![Alt text](/imgs/backicon.gif?raw=true)
  </li>
  <li>Position the back icon to the top left corner of the form.  You may have to reposition your gallery to accomodate the icon.</li>
  <li>Highlight the back icon and under its' advanced properties, change Onselect to <b>Navigate(BrowseScreen, ScreenTransition.UnCover)</b>
  
  ![Alt text](/imgs/backicononselect.gif?raw=true)
  </li>
  <li>Now we are ready to test.  Click <b>Preview the App icon</b> in the upper right and test your screen.  Within the BrowseScreen, search on a device and drill into it's details.  If everything works as expected, you have successfully completed this section.</li>
</ol>

# Pulling a Device Listing from Dynamics 365
Instead of having to know the device names, we can also pull a listing of Devices that we already have registered with IoT Hub.  For this example we will pull that listing from the IoT Devices entity within Dynamics 365.  This assumes that you have the <a href="https://docs.microsoft.com/en-us/dynamics365/customer-engagement/field-service/connected-field-service#connected-field-service-for-azure-iot-hub" target="_blank">Conneted Field Service for Iot Hub</a> installed and configured within a Dynamics 365 instance.
<br>&nbsp;<br>
<i>If you do not have access to a Dynamics 365 Connected Field Service for Iot Hub instance.  Alternatively you could use the <a href="https://docs.microsoft.com/en-us/azure/event-grid/overview" target="_blank">Event Grid</a> functionality in IoT Hub in conjunction with <a href="https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-overview" target="_blank">Logic Apps</a> to write your devices to an <a href = "https://docs.microsoft.com/en-us/azure/sql-database/sql-database-technical-overview" target="_blank">Azure SQL database</a> when a device is registered with IoT Hub.</i>

<ol start="46">
  <li>Our first step is to delete the <b>Text Input</b> and <b>Button</b> controls from the <b>BrowseScreen</b>.  We will not use them anymore.</li>
  <li>Let's add our data source.  From the menu bar select <b>View | Data sources</b> and click <b>Add data source</b>. </li>
  <li>If you already have used a Dynamics 365 Data Source that points to your specific D365 instance in another power app, it will show in the collection listing.  If not, click <b>New Connection</b> and select <b>Dynamics 365</b></li>
  <li>Select the appropriate D365 instance and for the <b>table</b> select <b>Iot Devices</b> and click <b>Connect</b>.  When finished, your data source should now show up in the listing...
  
  ![Alt text](/imgs/d365datasource.gif?raw=true)
  </li>
  <li>From the menu bar select <b>Insert | Controls | Drop Down</b>...
  
  ![Alt text](/imgs/insertdropdown.gif?raw=true)
  </li>
  <li>Move it to just above the <b>Gallery</b> on the <b>BrowseScreen</b> as we will need to leave room at the top for a reload control in a later step.</li>
  <li>With the Dropdown control highligted, modify the following under the <b>Properties</b> tab...
    <ol>
    <li>Items=<b>Iot Devices</b></li>
    <li>Value=<b>Name</b></li>
    </ol>
  <li>On the <b>Advanced</b> tab, set the following values...</li>
    <ol>
    <li>OnSelect=<b>ClearCollect(queryResults,[Your First Power App created].Run(Dropdown1.Selected.Value))</b></li>
    <li>OnChange=<b>ClearCollect(queryResults,[Your First Power App created].Run(Dropdown1.Selected.Value))</b>
    
  ![Alt text](/imgs/dropdownadvanced.gif?raw=true)
    </li>
    </ol>
  <li>If you test this functionality with the Preview the app button, you will notice that the query only returns values from the Cosmos DB when you change the value in the drop down, but it will not execute on the initial value shown.<br>  To fix that we will add a reload control to the BrowseScreen.  From the menu bar select <b>Insert | Icons | Reload</b> and add it to the top right of the BrowseScreen. </li>
  <li>With the icon selected, modify the following value on the <b>Advanced</b> tab...  OnSelect=<b>ClearCollect(queryResults,[Your First Power App created].Run(Dropdown1.Selected.Value))</b>

  ![Alt text](/imgs/icononselect.gif?raw=true)
  </li>
  <li>Now we are ready to test.  Click <b>Preview the App icon</b> in the upper right and test your dropdown and reload controls with the listing.  If everything works as expected, you have successfully completed this section.</li>
</ol>
