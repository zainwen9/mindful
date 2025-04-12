const { query } = require('express');
const {Pool} = require('pg');
const pool = new Pool({
  connectionString: "postgresql://echomind_user:MXgD4DhnTNipE4VXy8yitVfb01nai6X1@dpg-cvt0a115pdvs739dbldg-a.oregon-postgres.render.com/echomind",
    ssl: {
        rejectUnauthorized: false
    }
});

module.exports = {
    query: (text, params) => pool.query(text, params),

};

