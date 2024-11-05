const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const router = express.Router();
const { authMiddleware } = require('../middleware/authMiddleware');  // same as module.exports = { authMiddleware }; {}curly brace

// Register User
router.post('/register', async (req, res) => {
 
  try {
    const { username, email, getPassword, role } = req.body;
// console.log(username);
// console.log(email);
// console.log(getPassword);
// console.log(role);
    // Hash the password before saving
    const password = await bcrypt.hash(getPassword, 8);
    // console.log(password);
    // Create new user with hashed password
    const user = new User({ username, email, password, role });
    // console.log(user);
    const savedUser = await user.save();

    res.status(201).json({ message: 'User registered successfully', savedUser });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// Login User
router.post('/login', async (req, res) => {
  
  try {
    const { email, password } = req.body;

    // Find user by email
    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Validate password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ message: 'Invalid credentials' });

    // Generate JWT
    const token = jwt.sign({ id: user._id, role: user.role }, process.env.JWT_SECRET, {
      expiresIn: '1d',
    });

    res.json({ token, role: user.role });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Protected Route Example
router.get('/dashboard', authMiddleware, (req, res) => {
  // console.log('dashboard api call');
  const  role  = req.user.role;
// console.log(role);
  // Send different responses based on the user role
  switch (role) {
    case 'doctor':
      return res.send('Doctor');
    case 'patient':
      return res.send('Patient');
    case 'pharmacist':
      return res.send('Pharmacist');
    case 'lab_technician':
      return res.send('Lab Technician');
    case 'admin':
      return res.send('Admin');
    default:
      return res.status(403).send('Access Denied');
  }
});

module.exports = router;
