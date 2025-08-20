# Getting Started with DocumentDB Extension Playground

Welcome to the DocumentDB Extension Playground! This repository is designed to help you learn and explore the DocumentDB for VS Code extension with realistic healthcare data.

## 🏗️ Repository Structure

```
documentdb-extension-playground/
├── README.md                    # Main documentation and walkthrough
├── GETTING_STARTED.md          # This file - quick start guide
├── azure.yaml                  # Azure deployment configuration
├── infra/                      # Infrastructure as Code
│   ├── main.bicep             # Main Bicep template
│   ├── documentdb.bicep       # DocumentDB-specific template
│   └── main.parameters.json   # Deployment parameters
├── data/                       # Sample data
│   └── healthcare/            # Healthcare database
│       ├── patients.json      # Patient information
│       ├── appointments.json  # Medical appointments
│       ├── medical_records.json # Detailed health records
│       ├── billing.json       # Financial transactions
│       └── sample-queries.mongo # Sample queries to try
└── scripts/                   # Setup scripts
    ├── setup-documentdb.sh    # Linux/macOS setup
    └── setup-documentdb.ps1   # Windows setup
```

## 🚀 Quick Start

### 1. Prerequisites
- [DocumentDB for VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-documentdb)
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Visual Studio Code](https://code.visualstudio.com/)

### 2. Start Local DocumentDB

**Windows:**
```powershell
.\scripts\setup-documentdb.ps1
```

**Linux/macOS:**
```bash
chmod +x scripts/setup-documentdb.sh
./scripts/setup-documentdb.sh
```

### 3. Connect with VS Code Extension
1. Open VS Code
2. Click the DocumentDB icon in the sidebar
3. Click "Add New Connection"
4. Use connection string:
   ```
   mongodb://admin:password123@localhost:10260/?tls=true&tlsAllowInvalidCertificates=true&authMechanism=SCRAM-SHA-256
   ```

### 4. Create Database and Collections
1. Right-click your connection → "Create Database..." → Name it `healthcare`
2. Right-click the `healthcare` database → "Create Collection..." → Create:
   - `patients`
   - `appointments`
   - `medical_records`
   - `billing`

### 5. Import Sample Data
1. Right-click each collection → "Import"
2. Select the corresponding JSON file from `data/healthcare/`
3. Import in this order: `patients.json`, `appointments.json`, `medical_records.json`, `billing.json`

## 📚 Learning Path

### Beginner Level
1. **Explore Data Views** - Try Table, Tree, and JSON views
2. **Basic Queries** - Start with simple `find()` operations
3. **CRUD Operations** - Create, read, update, delete documents

### Intermediate Level
1. **Complex Queries** - Use filters, projections, and sorting
2. **Indexing** - Create indexes for better performance
3. **Aggregation** - Use aggregation pipelines for data analysis

### Advanced Level
1. **Join Operations** - Use `$lookup` for related data
2. **Data Analysis** - Complex aggregations and reporting
3. **Performance Optimization** - Query optimization and indexing strategies

## 🎯 Sample Scenarios

### Scenario 1: Patient Management
- Find patients by insurance provider
- Update patient contact information
- Add new allergies to patient records

### Scenario 2: Appointment Scheduling
- Find upcoming appointments
- Schedule new appointments
- Analyze appointment patterns by specialty

### Scenario 3: Medical Records Analysis
- Find patients with specific diagnoses
- Analyze vital signs trends
- Generate patient demographics reports

### Scenario 4: Billing and Finance
- Track payment status
- Calculate revenue by insurance provider
- Analyze billing patterns

## 🔧 Useful Queries

### Quick Patient Lookup
```javascript
db.patients.find({ lastName: "Smith" })
```

### Insurance Analysis
```javascript
db.patients.aggregate([
  { $group: { _id: "$insurance.provider", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
])
```

### Appointment Summary
```javascript
db.appointments.aggregate([
  { $group: { _id: "$specialty", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
])
```

## 🛠️ Troubleshooting

### Connection Issues
- Ensure Docker is running
- Check that port 10260 is available
- Verify the connection string format

### Import Issues
- Ensure JSON files are properly formatted
- Check file permissions
- Verify collection names match exactly

### Query Issues
- Use the sample queries in `data/healthcare/sample-queries.mongo`
- Check MongoDB syntax documentation
- Use the extension's query validation features

## 📖 Next Steps

1. **Explore the Extension Features**
   - Try different data views
   - Use the query editor with syntax highlighting
   - Experiment with import/export functionality

2. **Practice with Real Data**
   - Modify the sample data
   - Create your own queries
   - Build custom aggregation pipelines

3. **Advanced Topics**
   - Learn about indexing strategies
   - Explore geospatial queries
   - Try full-text search features

4. **Connect to Cloud**
   - Set up Azure Cosmos DB
   - Use service discovery features
   - Explore cloud-specific capabilities

## 🤝 Getting Help

- **Extension Documentation**: Built-in help in VS Code
- **Community Support**: [Discord channel](https://discord.gg/vH7bYu524D)
- **GitHub Issues**: [Extension repository](https://github.com/microsoft/vscode-documentdb)
- **DocumentDB Documentation**: [Official docs](https://github.com/microsoft/documentdb)

## 📝 Contributing

This playground is designed to be educational and extensible. Feel free to:
- Add more sample data
- Create additional query examples
- Improve documentation
- Share your learning experiences

Happy exploring! 🎉
