const express = require('express');
const dotenv = require('dotenv');
const http = require('http');
// import routes
const authRoutes = require('./routes/auth');

//init 
dotenv.config();
const app = express();

app.use(express.json());


// route middleware
app.use('/api/auth/', authRoutes);

const port = process.env.PORT || 3000;
http.createServer(app).listen(port, () => console.log(`server is running on port :${port}`));