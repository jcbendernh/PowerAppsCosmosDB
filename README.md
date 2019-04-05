# PowerAppsCosmosDB
This is a lab to walk users through how to create a PowerApp to read from Azure Cosmos DB via Flow.

This tutorial is based on the assumption that you already have an <a href="http://www.mxchip.com/az3166" target="_blank">MX Chip</a> connected to an <a href="https://docs.microsoft.com/en-us/azure/iot-hub/about-iot-hub" target="_blank">IoT Hub</a> and <a href="https://docs.microsoft.com/en-us/azure/stream-analytics/stream-analytics-introduction" target="_blank">Stream Analytics</a> is processing the messages and writing this information to a SQL API based <a href="https://docs.microsoft.com/en-us/azure/cosmos-db/introduction" target="_blank">Cosmos DB</a>.  We will then use <a href="https://flow.microsoft.com" target="_blank">Microsoft Flow</a> to process and structure that no SQL data stored in the Cosmos DB json documents and pass it to <a href="https://powerapps.microsoft.com" target="_blank">Power Apps</a> in a structured manner so it can process and render the data in the Power Apps GUI.  

![Alt text](/imgs/Architecture.gif?raw=true "Overall Architecture")

