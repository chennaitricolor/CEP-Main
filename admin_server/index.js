const express = require('express');
const dotenv = require('dotenv');
// import routes
const authRoutes = require('./routes/auth');

//init 
dotenv.config();
const app = express();

app.use(express.json());


// route middleware
app.use('/api/auth/', authRoutes);


app.listen(3000, () => console.log("server is running on port 3000"));