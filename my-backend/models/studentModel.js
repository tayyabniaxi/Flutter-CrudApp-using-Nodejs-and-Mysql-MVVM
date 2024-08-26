const db = require('../config/db');

// Get all students
exports.getAllStudents = (callback) => {
  const sql = "SELECT * FROM student";
  db.query(sql, (err, results) => {
    if (err) return callback(err);
    callback(null, results);
  });
};

// Create a new student
exports.createStudent = (name, email, password, callback) => {
  const sql = "INSERT INTO student (name, email, password) VALUES (?, ?, ?)";
  db.query(sql, [name, email, password], (err, result) => {
    if (err) return callback(err);
    callback(null, result);
  });
};

// Update a student by ID
exports.updateStudent = (id, name, email, password, callback) => {
  const sql = "UPDATE student SET name = ?, email = ?, password = ? WHERE id = ?";
  db.query(sql, [name, email, password, id], (err, result) => {
    if (err) return callback(err);
    callback(null, result);
  });
};

// Delete a student by ID
exports.deleteStudent = (id, callback) => {
  const sql = "DELETE FROM student WHERE id = ?";
  db.query(sql, [id], (err, result) => {
    if (err) return callback(err);
    callback(null, result);
  });
};
