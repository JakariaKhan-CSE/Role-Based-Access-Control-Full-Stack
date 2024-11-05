const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const authRoutes = require('./routes/auth');
require('dotenv').config();

const app = express();

mongoose.connect(process.env.MONGO_URI).then(()=>console.log('db Connected')).catch((err)=>{
    console.log(`error is: ${err}`);
})

// Middleware
app.use(cors());  //, adding cors middleware makes the setup simple and allows all or specific origins to access the backend resources as needed.
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);



  app.listen(process.env.PORT || 3002, ()=>{
    console.log(`Example app listening app on port ${process.env.PORT}`);
});