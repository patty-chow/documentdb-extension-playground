# DocumentDB Extension Playground

Learn how to use the DocumentDB for VS Code extension! This repository contains sample healthcare data and step-by-step instructions for setting up a local DocumentDB instance using Docker, connecting to it via the VS Code extension, and exploring all the features of the DocumentDB for VS Code extension.

* [Prerequisites](#prerequisites)
* [Explore a healthcare database with DocumentDB](#explore-a-healthcare-database-with-documentdb)
* [Use multiple data views](#use-multiple-data-views)
* [Perform CRUD operations](#perform-crud-operations)
* [Create indexes and run aggregation queries](#create-indexes-and-run-aggregation-queries)
* [Import and export data](#import-and-export-data)

## Prerequisites

* [DocumentDB for VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-documentdb)
* [Docker Desktop](https://www.docker.com/products/docker-desktop)
* [Visual Studio Code](https://code.visualstudio.com/)

## Explore a healthcare database with DocumentDB

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
   - Click "Test Connection" to verify connectivity
   - Click "Save Connection"

3. **Create a healthcare database:**
   - In the DocumentDB extension, right-click on your connection and select "Create Database..."
   - Enter `healthcare` as the database name and confirm

4. **Create collections for healthcare data:**
   - Right-click on the `healthcare` database and select "Create Collection..."
   - Create these collections:
     - `patients` - Patient information
     - `appointments` - Medical appointments
     - `medical_records` - Detailed health records
     - `billing` - Financial transactions

5. **Import sample healthcare data:**
   - Right-click on the `patients` collection and select "Import"
   - Choose `data/healthcare/patients.json` from this repository
   - Repeat for other collections using their respective JSON files

6. **Explore the database structure:**
   - Click on the `healthcare` database to expand it
   - Click on the `patients` collection to view documents
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
   - Right-click on the `patients` collection and select "Create Document"
   - Fill in the fields in the table format
   - Click "Save" to create the document

2. **Using the JSON View:**
   - Right-click on the `patients` collection and select "Create Document"
   - Enter JSON directly:
     ```json
     {
       "patientId": "P10001",
       "firstName": "John",
       "lastName": "Smith",
       "dateOfBirth": "1985-03-15",
       "email": "john.smith@email.com",
       "phone": "+1-555-0123",
       "address": {
         "street": "123 Main St",
         "city": "Springfield",
         "state": "IL",
         "zipCode": "62701"
       },
       "insurance": {
         "provider": "Blue Cross",
         "policyNumber": "BC123456789"
       },
       "createdAt": new Date()
     }
     ```

### Read documents

1. **Basic queries:**
   - Right-click on the `patients` collection and select "New Query"
   - Try these queries:
     ```javascript
     // Find all patients
     db.patients.find({})
     
     // Find patients by last name
     db.patients.find({ lastName: "Smith" })
     
     // Find patients with specific insurance
     db.patients.find({ "insurance.provider": "Blue Cross" })
     ```

2. **Query with projections:**
   ```javascript
   // Get only patient names and emails
   db.patients.find({}, { firstName: 1, lastName: 1, email: 1, _id: 0 })
   ```

### Update documents

1. **Update a single document:**
   ```javascript
   // Update a patient's phone number
   db.patients.updateOne(
     { patientId: "P10001" },
     { $set: { phone: "+1-555-9999" } }
   )
   ```

2. **Update multiple documents:**
   ```javascript
   // Update all patients with a specific insurance provider
   db.patients.updateMany(
     { "insurance.provider": "Blue Cross" },
     { $set: { "insurance.provider": "Blue Cross Blue Shield" } }
   )
   ```

### Delete documents

1. **Delete a single document:**
   ```javascript
   // Delete a specific patient
   db.patients.deleteOne({ patientId: "P10001" })
   ```

2. **Delete multiple documents:**
   ```javascript
   // Delete all patients with a specific last name
   db.patients.deleteMany({ lastName: "Smith" })
   ```

## Create indexes and run aggregation queries

### Creating indexes

1. **Single field index:**
   ```javascript
   // Create an index on patientId for faster lookups
   db.patients.createIndex({ "patientId": 1 })
   ```

2. **Compound index:**
   ```javascript
   // Create an index on lastName and firstName
   db.patients.createIndex({ "lastName": 1, "firstName": 1 })
   ```

3. **Text index for search:**
   ```javascript
   // Create a text index for searching patient names
   db.patients.createIndex({ "firstName": "text", "lastName": "text" })
   ```

### Aggregation queries

1. **Basic aggregation - count patients by insurance provider:**
   ```javascript
   db.patients.aggregate([
     { $group: { _id: "$insurance.provider", count: { $sum: 1 } } },
     { $sort: { count: -1 } }
   ])
   ```

2. **Complex aggregation - patient demographics:**
   ```javascript
   db.patients.aggregate([
     {
       $addFields: {
         age: {
           $floor: {
             $divide: [
               { $subtract: [new Date(), { $dateFromString: { dateString: "$dateOfBirth" } }] },
               365 * 24 * 60 * 60 * 1000
             ]
           }
         }
       }
     },
     {
       $group: {
         _id: {
           ageGroup: {
             $cond: {
               if: { $lt: ["$age", 30] },
               then: "18-29",
               else: {
                 $cond: {
                   if: { $lt: ["$age", 50] },
                   then: "30-49",
                   else: "50+"
                 }
               }
             }
           }
         },
         count: { $sum: 1 },
         avgAge: { $avg: "$age" }
       }
     },
     { $sort: { "_id.ageGroup": 1 } }
   ])
   ```

3. **Join-like aggregation with appointments:**
   ```javascript
   db.appointments.aggregate([
     {
       $lookup: {
         from: "patients",
         localField: "patientId",
         foreignField: "patientId",
         as: "patient"
       }
     },
     { $unwind: "$patient" },
     {
       $group: {
         _id: "$patient.lastName",
         appointmentCount: { $sum: 1 },
         totalDuration: { $sum: "$duration" }
       }
     },
     { $sort: { appointmentCount: -1 } }
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

This repository is provided under the MIT License. The sample healthcare data is fictional and created for educational purposes only.
