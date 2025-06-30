// Simple script to drop all collections in MongoDB
const { MongoClient } = require('mongodb');
require('dotenv').config({ path: '.env.development' });

const uri = process.env.MONGO_URI;
const client = new MongoClient(uri);

async function dropAllCollections() {
  try {
    await client.connect();
    console.log('Connected to MongoDB');
    
    const db = client.db();
    const collections = await db.listCollections().toArray();
    
    console.log(`Found ${collections.length} collections`);
    
    for (const collection of collections) {
      try {
        await db.collection(collection.name).deleteMany({});
        console.log(`Deleted all documents from collection: ${collection.name}`);
      } catch (error) {
        console.error(`Error deleting documents from ${collection.name}:`, error);
      }
    }
    
    console.log('All collections cleared successfully');
  } catch (error) {
    console.error('Error:', error);
  } finally {
    await client.close();
    console.log('Disconnected from MongoDB');
  }
}

dropAllCollections(); 