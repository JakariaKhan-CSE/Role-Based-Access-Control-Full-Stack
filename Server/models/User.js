const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: false },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  role: { 
    type: String, 
    enum: ['admin', 'doctor', 'patient', 'pharmacist', 'lab_technician'],
    required: true 
  },
});



module.exports = mongoose.model('User', userSchema);
