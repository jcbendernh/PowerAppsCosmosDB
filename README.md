# PowerAppsCosmosDB
This is a lab to walk users through how to create a PowerApp to read unstructured/no-SQL data from Azure Cosmos DB via Flow.

This tutorial is based on the assumption that you already have an <a href="http://www.mxchip.com/az3166" target="_blank">MX Chip</a> connected to an <a href="https://docs.microsoft.com/en-us/azure/iot-hub/about-iot-hub" target="_blank">IoT Hub</a> and <a href="https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction" target="_blank">Stream Analytics</a> is processing the messages and writing this information to a SQL API based <a href="https://docs.microsoft.com/en-us/azure/cosmos-db/introduction" target="_blank">Cosmos DB</a>.  We will then use <a href="https://flow.microsoft.com" target="_blank">Microsoft Flow</a> to process and structure that no-SQL data stored in the Cosmos DB json documents and pass it to <a href="https://powerapps.microsoft.com" target="_blank">Power Apps</a> in a structured manner so it can process and render the data in the Power Apps GUI.  

Below is a representation of the overall architecture of this solution.  For this lab, we will just focus on the Flow and PowerApp component to pull from a document directory in Cosmos DB.  The stream analytics query used for this sample is included in the files firectory of this repository.

![Alt text](/imgs/Architecture.gif?raw=true "Overall Architecture")

For this walkthrough, as a reference I have an Azure Cosmos Database using the SQL API that is housing json documents in a collection called <b> Telemetry</b> in a database called <b>IoT</b>...

![Alt text](/imgs/cosmos.gif?raw=true "Cosmos DB")

Our first step is to go into Flow and create a flow to read from Cosmos DB supply a structured data set to PowerApps.

<ol>
  <li>Go to https://flow.microsoft.com/ and log in.</li>
  <li>Click on <b>My Flows</b> on the left navigation bar and select <b>New</b> along the top and select <b>Create from blank</b>.</li>
  <li>You will then be presented with the screen below.  Click Create from blank one more time.</li>
  ![Alt text](/imgs/createfromblank.gif?raw=true "Cosmos DB") 
</ol>
