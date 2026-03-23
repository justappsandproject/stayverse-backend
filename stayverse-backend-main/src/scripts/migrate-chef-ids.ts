import { connect, Types, connection } from 'mongoose';
import * as dotenv from 'dotenv';

// Load environment variables
dotenv.config();

// MongoDB connection string from environment variables
const MONGODB_URI = process.env.DATABASE_URL;

async function migrateChefIds() {
  try {
    console.log('Connecting to MongoDB...');
    await connect(MONGODB_URI);
    console.log('Connected to MongoDB successfully');

    // Get the collections
    const db = connection.db;
    const experiencesCollection = db.collection('experiences');
    const certificationsCollection = db.collection('certifications');

    // Find experiences with string chefIds
    console.log('Finding experiences with string chefIds...');
    const experiences = await experiencesCollection.find({
      chefId: { $type: 'string' }
    }).toArray();
    console.log(`Found ${experiences.length} experiences with string chefIds`);

    // Update experiences
    if (experiences.length > 0) {
      console.log('Updating experiences...');
      let successCount = 0;
      
      for (const experience of experiences) {
        try {
          // Convert string to ObjectId
          const objectId = new Types.ObjectId(experience.chefId);
          

          await experiencesCollection.updateOne(
            { _id: experience._id },
            { $set: { chefId: objectId } }
          );
          
          successCount++;
        } catch (error) {
          console.error(`Failed to update experience ${experience._id}:`, error);
        }
      }
      
      console.log(`Successfully updated ${successCount} out of ${experiences.length} experiences`);
    }

    // Find certifications with string chefIds
    console.log('Finding certifications with string chefIds...');
    const certifications = await certificationsCollection.find({
      chefId: { $type: 'string' }
    }).toArray();
    console.log(`Found ${certifications.length} certifications with string chefIds`);

    // Update certifications
    if (certifications.length > 0) {
      console.log('Updating certifications...');
      let successCount = 0;
      
      for (const certification of certifications) {
        try {
          // Convert string to ObjectId
          const objectId = new Types.ObjectId(certification.chefId);
          
          // Update the document
          await certificationsCollection.updateOne(
            { _id: certification._id },
            { $set: { chefId: objectId } }
          );
          
          successCount++;
        } catch (error) {
          console.error(`Failed to update certification ${certification._id}:`, error);
        }
      }
      
      console.log(`Successfully updated ${successCount} out of ${certifications.length} certifications`);
    }

    console.log('Migration completed successfully');
  } catch (error) {
    console.error('Migration failed:', error);
  } finally {
    // Close the connection
    await connection.close();
    console.log('MongoDB connection closed');
  }
}

// Run the migration
migrateChefIds().catch(console.error);
