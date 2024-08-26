const Student = require('../models/studentModel');

// Get all students
exports.getAllStudents = (req, res) => {
  Student.getAllStudents((err, data) => {
    if (err) {
      console.error("Error fetching students:", err);
      return res.status(500).json({ error: "Server error" });
    }
    res.json(data);
  });
};

// Create a new student
exports.createStudent = (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    console.error("Missing name, email, or password");
    return res.status(400).json({ error: "Missing name, email, or password" });
  }

  Student.createStudent(name, email, password, (err, result) => {
    if (err) {
      console.error("Error creating student:", err);
      return res.status(500).json({ error: "Server error" });
    }
    res.json({ status: "success", result });
  });
};

// Update a student by ID
exports.updateStudent = (req, res) => {
  const { name, email, password } = req.body;
  const id = req.params.id;

  if (!name || !email || !password) {
    console.error("Missing name, email, or password");
    return res.status(400).json({ error: "Missing name, email, or password" });
  }

  Student.updateStudent(id, name, email, password, (err, result) => {
    if (err) {
      console.error("Error updating student:", err);
      return res.status(500).json({ error: "Server error" });
    }
    res.json({ status: "success", result });
  });
};

// Delete a student by ID
exports.deleteStudent = (req, res) => {
  const id = req.params.id;

  Student.deleteStudent(id, (err, result) => {
    if (err) {
      console.error("Error deleting student:", err);
      return res.status(500).json({ error: "Server error" });
    }
    res.json({ status: "success", result });
  });
};
