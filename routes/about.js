const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.send({ name: 'This ist just helath' });
});

module.export = router;
