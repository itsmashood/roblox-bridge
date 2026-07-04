const express = require("express");
const app = express();

app.use(express.json());

//-----------------------------
// STORAGE
//-----------------------------
let queue = [];

//-----------------------------
// DEBUG MIDDLEWARE
//-----------------------------
app.use((req, res, next) => {
    console.log("\n==============================");
    console.log("REQUEST:", req.method, req.url);
    console.log("BODY:", req.body);
    next();
});

//-----------------------------
// HEALTH CHECK (RENDER REQUIRED)
//-----------------------------
app.get("/", (req, res) => {
    res.status(200).send("OK - backend running");
});

// optional extra health endpoint (some hosts use this)
app.get("/healthz", (req, res) => {
    res.status(200).send("healthy");
});

//-----------------------------
// ADD SERVER (ROBLOX → BACKEND)
//-----------------------------
app.post("/add", (req, res) => {
    try {
        const { placeId, serverId, username } = req.body;

        if (!placeId || !serverId) {
            console.log("❌ INVALID DATA RECEIVED");
            return res.status(400).json({ ok: false, error: "missing data" });
        }

        const entry = {
            placeId: String(placeId),
            serverId: String(serverId),
            username: username || "unknown",
            status: "pending",
            time: Date.now()
        };

        queue.push(entry);

        console.log("✅ ADDED SERVER:");
        console.log(entry);

        console.log("📦 QUEUE SIZE:", queue.length);

        return res.json({ ok: true });

    } catch (err) {
        console.log("❌ ERROR IN /add:", err);
        return res.status(500).json({ ok: false });
    }
});

//-----------------------------
// GET QUEUE (ALT READS THIS)
//-----------------------------
app.get("/queue", (req, res) => {
    res.json({ queue });
});

//-----------------------------
// START SERVER
//-----------------------------
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log("=================================");
    console.log("🚀 SERVER RUNNING ON PORT", PORT);
    console.log("=================================");
});
