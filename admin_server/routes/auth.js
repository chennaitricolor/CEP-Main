const router = require('express').Router();
const axios = require('axios');
const jwt = require('jsonwebtoken');

const MSG91_URL = "https://control.msg91.com/api/";

//----------Send OTP--------------
router.post('/sendotp', async (req, res) => {
  
  try {

    const params = {
      country: req.body.country_code,
      mobile: req.body.mobile_no,
      authkey: process.env.MSG91_API_KEY,
      otp_expiry: "10",
      sender: "HLOCHN",
      message: "Your Hello Chennai app OTP is ##OTP##"
    };
    
    const { data } = await axios.post(MSG91_URL+"sendotp.php",null, { params });

    if(data.type === 'error'){

      res.status(400).send({
        message: ""+data.message,
        status: "failed"
      });

    } else {
      
      res.status(200).send({
        message: "sms sent",
        status: "success"
      });

    }

  } catch (error) {

    console.log(error);
    res.status(500).send({
      message: "internal error",
      status: "failed",
      error: ""+error
    });

  }
});

//----------Resend OTP--------------
router.post('/resendotp', async (req, res) => {
  
  try {

    const params = {
      country: req.body.country_code,
      mobile: req.body.mobile_no,
      authkey: process.env.MSG91_API_KEY,
      retrytype: "text"
    };
    
    const { data } = await axios.post(MSG91_URL+"retryotp.php", null, { params });

    if (data.type === 'error') {

      res.status(400).send({
        message: ""+data.message,
        status: "failed"
      });

    } else {

      res.status(200).send({
        message: "sms resent",
        status: "success"
      });

    }

  } catch (error) {

    console.log(error);
    res.status(500).send({
      message: "internal error",
      status: "failed",
      error: "" + error
    });

  }
});

//----------Verify OTP--------------
router.post('/verifyotp', async (req, res) => {
  
  try {

    const params = {
      country: req.body.country_code,
      mobile: req.body.mobile_no,
      authkey: process.env.MSG91_API_KEY,
      otp: req.body.otp
    };

    const { data } = await axios.post(MSG91_URL+"verifyRequestOTP.php", null, { params });

    if (data.type === 'error') {

      res.status(400).send({
        message: ""+data.message,
        status: "failed"
      });

    } else {
      
      res.status(200).send({
        message: "otp verified",
        status: "success",
        authtoken: jwt.sign({
          "https://hasura.io/jwt/claims": {
            "x-hasura-allowed-roles": ["user"],
            "x-hasura-default-role": "user",
            'x-Hasura-mobile-no': req.body.mobile_no.toString()
          },
        },
          process.env.JWT_SECRET,
          { algorithm: 'HS256' })
      });

    }



  } catch (error) {

    console.log(error);
    res.status(500).send({
      message: "internal error",
      status: "failed",
      error: "" + error
    });

  }
});


router.post('/getmicroapptoken', (req, res) => {
  try {
    console.log("getmicroapptoken");
    const platform_token = req.header('CEP-Token');
    
    try {
      decoded = jwt.verify(platform_token, process.env.JWT_SECRET, { algorithm: 'HS256' });  
    } catch (error) {
      res.status(400).send({
        message: "invalid token",
        status: "failed"
      });
      return;
    }
    
    res.status(200).send({
      status: "success",
      microapptoken: jwt.sign({
        "https://hasura.io/jwt/claims": {
          "x-hasura-allowed-roles": [req.body.app_id],
          "x-hasura-default-role": req.body.app_id,
          'x-Hasura-mobile-no': decoded.mobile_no
        },
      },
        process.env.JWT_SECRET,
        { algorithm: 'HS256' })
    });

  } catch (error) {
    res.status(500).send({
      message: "internal error",
      status: "failed"
    });
  }
})


module.exports = router;