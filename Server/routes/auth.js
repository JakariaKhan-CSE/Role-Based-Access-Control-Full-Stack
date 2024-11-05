const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const router = express.Router();
const { authMiddleware } = require('../middleware/authMiddleware');  // same as module.exports = { authMiddleware }; {}curly brace

// Register User
router.post('/register', async (req, res) => {
  try {
    const { username, email, password, role } = req.body;

    // Create new user
    const user = new User({ username, email, password, role });
    await user.save();

    res.status(201).json({ message: 'User registered successfully' });
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
  const { role } = req.user;

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
