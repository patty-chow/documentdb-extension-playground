# Getting Started with DocumentDB Extension Playground

Welcome to the DocumentDB Extension Playground! This repository is designed to help you learn and explore the DocumentDB for VS Code extension with realistic e-commerce data from an Adventure Works bicycle shop.

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
│   ├── customer.json          # Customer information and sales orders
│   ├── product.json           # Product catalog with categories and tags
│   └── productMeta.json       # Product categories and metadata
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
1. Right-click your connection → "Create Database..." → Name it `adventureworks`
2. Right-click the `adventureworks` database → "Create Collection..." → Create:
   - `customers` - Customer information and sales orders
   - `products` - Product catalog with categories and tags
   - `categories` - Product categories and metadata

### 5. Import Sample Data
1. Right-click each collection → "Import"
2. Select the corresponding JSON file from `data/`:
   - `customers` collection: `customer.json`
   - `products` collection: `product.json`
   - `categories` collection: `productMeta.json`

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

### Scenario 1: Customer Management
- Find customers by location or order history
- Update customer contact information
- Analyze customer purchasing patterns

### Scenario 2: Product Catalog
- Find products by category or price range
- Search products by tags or descriptions
- Analyze product pricing and availability

### Scenario 3: Sales Analysis
- Find top-selling products
- Analyze sales by customer segment
- Generate revenue reports by category

### Scenario 4: Inventory Management
- Track product categories and subcategories
- Analyze product relationships and tags
- Monitor product performance metrics

## 🔧 Useful Queries

### Quick Customer Lookup
```javascript
db.customers.find({ "lastName": "Perez" })
```

### Product Category Analysis
```javascript
db.products.aggregate([
  { $group: { _id: "$categoryName", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
])
```

### Sales Order Summary
```javascript
db.customers.aggregate([
  { $match: { "type": "salesOrder" } },
  { $group: { _id: "$customerId", orderCount: { $sum: 1 } } },
  { $sort: { orderCount: -1 } }
])
```

### Product Price Analysis
```javascript
db.products.aggregate([
  { $group: { _id: "$categoryName", avgPrice: { $avg: "$price" } } },
  { $sort: { avgPrice: -1 } }
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
- Use the sample queries provided above
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

- **DocumentDB Repository**: [Official Repo](https://github.com/documentdb/documentdb)
- **Community Support**: [Discord channel](https://discord.gg/vH7bYu524D)
- **GitHub Issues**: [Extension repository](https://github.com/microsoft/vscode-documentdb)
- **DocumentDB Documentation**: [Official docs](https://github.com/documentdb/docs)

## 📝 Contributing

This playground is designed to be educational and extensible. Feel free to:
- Add more sample data
- Create additional query examples
- Improve documentation
- Share your learning experiences

Happy exploring! 🎉
