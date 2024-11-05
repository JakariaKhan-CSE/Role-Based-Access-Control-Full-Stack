const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const authRoutes = require('./routes/auth');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());  //, adding cors middleware makes the setup simple and allows all or specific origins to access the backend resources as needed.
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);

// Connect to MongoDB and Start Server
mongoose.connect(process.env.MONGO_URI)
  .then(() => app.listen(process.env.PORT, () => console.log(`Server running on port ${process.env.PORT}`)))
  .catch((err) => console.log(err));
