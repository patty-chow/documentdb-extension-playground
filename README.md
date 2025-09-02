# DocumentDB Extension Playground

Learn how to use the DocumentDB for VS Code extension! This repository contains sample e-commerce data from Adventure Works bicycle shop and step-by-step instructions for setting up a local DocumentDB instance using Docker, connecting to it via the VS Code extension, and exploring all the features of the DocumentDB for VS Code extension.

* [Prerequisites](#prerequisites)
* [Explore an e-commerce database with DocumentDB](#explore-an-e-commerce-database-with-documentdb)
* [Use multiple data views](#use-multiple-data-views)
* [Perform CRUD operations](#perform-crud-operations)
* [Create indexes and run aggregation queries](#create-indexes-and-run-aggregation-queries)
* [Import and export data](#import-and-export-data)

## Prerequisites

* [DocumentDB for VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-documentdb)
* [Docker Desktop](https://www.docker.com/products/docker-desktop)
* [Visual Studio Code](https://code.visualstudio.com/)

## Explore an e-commerce database with DocumentDB

1. **Start a local DocumentDB instance using Docker:**

   ```bash
   docker pull ghcr.io/microsoft/documentdb/documentdb-local:latest
   docker tag ghcr.io/microsoft/documentdb/documentdb-local:latest documentdb
   docker run -dt -p 10260:10260 --name documentdb-container documentdb --username admin --password password123
   docker image rm -f ghcr.io/microsoft/documentdb/documentdb-local:latest || echo "No existing documentdb image to remove"
   ```

   > **Note:** We're using port `10260` to avoid conflicts with other local database services. You can use port `27017` (the standard MongoDB port) if you prefer.

2. **Connect to DocumentDB using the VS Code extension:**
   - Open VS Code and click the DocumentDB icon in the sidebar
   - Click "Add New Connection"
   - Select "Connection String" and paste:
     ```
     mongodb://admin:password123@localhost:10260/?tls=true&tlsAllowInvalidCertificates=true&authMechanism=SCRAM-SHA-256
     ```
   - Click "Enter" when prompted for your username and password

3. **Create an Adventure Works database:**
   - In the DocumentDB extension, right-click on your connection and select "Create Database..."
   - Enter `adventureworks` as the database name and confirm

4. **Create collections for e-commerce data:**
   - Right-click on the `adventureworks` database and select "Create Collection..."
   - Create these collections:
     - `customers` - Customer information and sales orders
     - `products` - Product catalog with categories and tags
     - `categories` - Product categories and metadata

5. **Import sample e-commerce data:**
   - Right-click on the `customers` collection and select "Import Documents into Collection..."
   - Choose `data/customer.json` from this repository
   - Repeat for other collections using their respective JSON files:
     - `products` collection: `data/product.json`
     - `categories` collection: `data/productMeta.json`

6. **Explore the database structure:**
   - Click on the `adventureworks` database to expand it
   - Click on the `customers` collection to view documents
   - Notice the different data views available (Table, Tree, JSON)

## Use multiple data views

The DocumentDB extension provides three different ways to view your data:

1. **Table View** (default):
   - View documents in a spreadsheet-like format
   - Sort by clicking column headers
   - Use the filter bar to search for specific values
   - Navigate through pages of data

2. **Tree View**:
   - See document structure as an expandable tree
   - Click on nodes to expand/collapse nested objects
   - Easily navigate complex document structures
   - Right-click on the collection and select "Tree View"

3. **JSON View**:
   - View documents in their native JSON format
   - See syntax-highlighted, formatted JSON
   - Right-click on the collection and select "JSON View"

Try switching between these views to see how the same data is presented differently!

## Perform CRUD operations

### Create documents

1. **Using the Table View:**
   - Right-click on the `customers` collection and select "Create Document"
   - Fill in the fields in the table format
   - Click "Save" to create the document

2. **Using the JSON View:**
   - Right-click on the `customers` collection and select "Create Document"
   - Enter JSON directly:
     ```json
     {
       "id": "NEW-CUSTOMER-001",
       "type": "customer",
       "customerId": "NEW-CUSTOMER-001",
       "title": "Mr.",
       "firstName": "John",
       "lastName": "Doe",
       "emailAddress": "john.doe@email.com",
       "phoneNumber": "+1-555-0123",
       "creationDate": "2024-01-20T13:45:00Z",
       "addresses": [
         {
           "addressLine1": "123 Main St",
           "addressLine2": "",
           "city": "Seattle",
           "state": "WA",
           "country": "US",
           "zipCode": "98101"
         }
       ],
       "password": {
         "hash": "sample-hash",
         "salt": "sample-salt"
       },
       "salesOrderCount": 0
     }
     ```

### Read documents

1. **Basic queries:**
   - Right-click on the `customers` collection and select "DocumentDB Scrapbook" > "New DocumentDB Scrapbook"
   - Try these queries:
     ```javascript
     // Find all customers
     db.customers.find({})
     
     // Find customers by last name
     db.customers.find({ lastName: "Perez" })
     
     // Find customers with specific order count
     db.customers.find({ "salesOrderCount": { $gt: 25 } })
     ```

2. **Query with projections:**
   ```javascript
   // Get only customer names and emails
   db.customers.find({}, { firstName: 1, lastName: 1, emailAddress: 1, _id: 0 })
   ```

### Update documents

1. **Update a single document:**
   ```javascript
   // Update a customer's phone number
   db.customers.updateOne(
     { customerId: "44A6D5F6-AF44-4B34-8AB5-21C5DC50926E" },
     { $set: { phoneNumber: "+1-555-9999" } }
   )
   ```

2. **Update multiple documents:**
   ```javascript
   // Update all customers with high order counts
   db.customers.updateMany(
     { "salesOrderCount": { $gt: 25 } },
     { $set: { "customerType": "VIP" } }
   )
   ```

### Delete documents

1. **Delete a single document:**
   ```javascript
   // Delete a specific customer
   db.customers.deleteOne({ customerId: "44A6D5F6-AF44-4B34-8AB5-21C5DC50926E" })
   ```

2. **Delete multiple documents:**
   ```javascript
   // Delete all customers with no orders
   db.customers.deleteMany({ salesOrderCount: 0 })
   ```

## Create indexes and run aggregation queries

### Creating indexes

1. **Single field index:**
   ```javascript
   // Create an index on customerId for faster lookups
   db.customers.createIndex({ "customerId": 1 })
   ```

2. **Compound index:**
   ```javascript
   // Create an index on lastName and firstName
   db.customers.createIndex({ "lastName": 1, "firstName": 1 })
   ```

3. **Text index for search:**
   ```javascript
   // Create a text index for searching product names
   db.products.createIndex({ "name": "text", "description": "text" })
   ```

### Aggregation queries

1. **Basic aggregation - count products by category:**
   ```javascript
   db.products.aggregate([
     { $group: { _id: "$categoryName", count: { $sum: 1 } } },
     { $sort: { count: -1 } }
   ])
   ```

2. **Complex aggregation - product pricing analysis:**
   ```javascript
   db.products.aggregate([
     {
       $group: {
         _id: "$categoryName",
         count: { $sum: 1 },
         avgPrice: { $avg: "$price" },
         minPrice: { $min: "$price" },
         maxPrice: { $max: "$price" }
       }
     },
     { $sort: { avgPrice: -1 } }
   ])
   ```

3. **Join-like aggregation with customers and orders:**
   ```javascript
   db.customers.aggregate([
     {
       $match: { "type": "salesOrder" }
     },
     {
       $group: {
         _id: "$customerId",
         orderCount: { $sum: 1 },
         totalItems: { $sum: { $size: "$details" } }
       }
     },
     { $sort: { orderCount: -1 } }
   ])
   ```

4. **Product tag analysis:**
   ```javascript
   db.products.aggregate([
     { $unwind: "$tags" },
     {
       $group: {
         _id: "$tags.name",
         productCount: { $sum: 1 },
         avgPrice: { $avg: "$price" }
       }
     },
     { $sort: { productCount: -1 } }
   ])
   ```

## Import and export data

### Import data

1. **Import JSON files:**
   - Right-click on any collection and select "Import"
   - Choose a JSON file from your computer
   - The extension will automatically parse and import the documents

2. **Import from clipboard:**
   - Copy JSON data to your clipboard
   - Right-click on a collection and select "Import"
   - Paste the JSON data directly

### Export data

1. **Export collection:**
   - Right-click on a collection and select "Export"
   - Choose your preferred format (JSON, CSV)
   - Select a location to save the file

2. **Export query results:**
   - Run a query in the query editor
   - Click the "Export" button in the results panel
   - Choose format and save location

## Next steps

- **Explore advanced features:** Try full-text search, geospatial queries, and vector similarity search
- **Connect to cloud instances:** Set up connections to Azure Cosmos DB or MongoDB Atlas
- **Use service discovery:** Browse and connect to DocumentDB instances in your cloud environment
- **Join the community:** Visit our [GitHub repository](https://github.com/microsoft/vscode-documentdb) and [Discord channel](https://discord.gg/vH7bYu524D)

## Troubleshooting

### Common issues

1. **Connection fails:**
   - Ensure Docker is running and the DocumentDB container is started
   - Check that the port (10260) is not blocked by firewall
   - Verify the connection string format

2. **Import fails:**
   - Ensure your JSON file is properly formatted
   - Check that the file size is within limits
   - Verify you have write permissions to the collection

3. **Queries are slow:**
   - Create appropriate indexes for your query patterns
   - Use projections to limit returned fields
   - Consider using aggregation pipelines for complex operations

### Getting help

- **Extension documentation:** Check the built-in help in the extension
- **Community support:** Join our [Discord community](https://discord.gg/vH7bYu524D)
- **GitHub issues:** Report bugs on the [extension repository](https://github.com/microsoft/vscode-documentdb)

## Licensing

This repository is provided under the MIT License. The sample e-commerce data is fictional and created for educational purposes only.
