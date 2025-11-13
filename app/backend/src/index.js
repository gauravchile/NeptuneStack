import express from 'express';
import pkg from 'pg';
const { Pool } = pkg;


const app = express();
const port = process.env.PORT || 8080;


const pool = new Pool({
host: process.env.DB_HOST || 'postgres',
port: Number(process.env.DB_PORT || 5432),
user: process.env.DB_USER,
password: process.env.DB_PASSWORD,
database: process.env.DB_NAME || 'neptune'
});


app.get('/healthz', (req, res) => res.status(200).send('ok'));


app.get('/api/v1/ping', async (req, res) => {
try {
const r = await pool.query('SELECT NOW() as now');
res.json({ pong: true, db_time: r.rows[0].now });
} catch (e) {
res.status(500).json({ error: e.message });
}
});


app.listen(port, () => console.log(`Neptune API listening on ${port}`));
