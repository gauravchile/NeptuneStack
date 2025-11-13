import React, { useState, useEffect } from "react";
import { createRoot } from "react-dom/client";

function App() {
  const [data, setData] = useState(null);
  const [latency, setLatency] = useState(null);
  const [theme, setTheme] = useState("dark");
  const [lastRefresh, setLastRefresh] = useState(null);

  async function fetchStatus() {
    const start = performance.now();

    try {
      const res = await fetch("/api/ping");
      const json = await res.json();

      const end = performance.now();
      setLatency(Math.round(end - start));

      setData(json);
      setLastRefresh(new Date().toLocaleTimeString());
    } catch {
      setData({ error: "API unreachable" });
      setLatency(null);
      setLastRefresh(new Date().toLocaleTimeString());
    }
  }

  useEffect(() => {
    fetchStatus();
    const interval = setInterval(fetchStatus, 3000); // auto-refresh
    return () => clearInterval(interval);
  }, []);

  const isHealthy = !data?.error;
  const dbHealthy = !!data?.db_time;

  const bg = theme === "dark"
    ? "linear-gradient(135deg, #0f172a, #1e293b)"
    : "linear-gradient(135deg, #f1f5f9, #e2e8f0)";

  const textColor = theme === "dark" ? "white" : "#0f172a";

  return (
    <>
      <div
        style={{
          background: bg,
          minHeight: "100vh",
          padding: "40px",
          fontFamily: "Inter, system-ui",
          color: textColor,
        }}
      >
        {/* Header */}
        <div style={{
          maxWidth: "900px",
          margin: "0 auto 40px auto"
        }}>
          <div style={{ display: "flex", justifyContent: "space-between" }}>
            <h1 style={{ fontSize: "34px", fontWeight: 700 }}>
              🪐 Neptune Stack Dashboard
            </h1>
            <button
              onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
              style={{
                padding: "10px 18px",
                borderRadius: "8px",
                border: "none",
                background: theme === "dark" ? "white" : "#0f172a",
                color: theme === "dark" ? "#0f172a" : "white",
                cursor: "pointer",
              }}
            >
              {theme === "dark" ? "☀️ Light Mode" : "🌙 Dark Mode"}
            </button>
          </div>

          <p style={{ opacity: 0.7, marginTop: "10px" }}>
            Advanced DevOps Monitoring • Frontend ↔ API ↔ Database
          </p>
        </div>

        {/* STATUS BAR */}
        <div style={{
          maxWidth: "900px",
          margin: "0 auto 30px auto",
          padding: "18px",
          borderRadius: "12px",
          background: theme === "dark"
            ? "rgba(255, 255, 255, 0.08)"
            : "rgba(0, 0, 0, 0.08)",
          display: "flex",
          justifyContent: "space-between",
          fontSize: "15px",
        }}>
          <div>🟢 Frontend: OK</div>
          <div>{isHealthy ? "🟢 API: Healthy" : "🔴 API: DOWN"}</div>
          <div>{dbHealthy ? "🟢 DB Connected" : "🔴 DB Error"}</div>
        </div>

        {/* GRID CARDS */}
        <div style={{
          maxWidth: "900px",
          margin: "0 auto",
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(260px, 1fr))",
          gap: "20px",
        }}>
          {/* API STATUS CARD */}
          <Card title="API Status">
            <p style={{ fontSize: "16px" }}>
              {isHealthy ? "🟢 Online" : "🔴 Offline"}
            </p>
            <p style={{ opacity: 0.7 }}>
              Last refresh: {lastRefresh}
            </p>
          </Card>

          {/* LATENCY CARD */}
          <Card title="API Latency">
            <p style={{ fontSize: "16px" }}>
              {latency ? `${latency} ms` : "—"}
            </p>
            <p style={{ opacity: 0.7 }}>
              Round-trip from frontend → backend
            </p>
          </Card>

          {/* DB TIME CARD */}
          <Card title="Database Time">
            {dbHealthy ? (
              <p>{new Date(data.db_time).toLocaleString()}</p>
            ) : (
              <p>—</p>
            )}
          </Card>

          {/* RAW DATA */}
          <Card title="API Raw Response" span={2}>
            <pre
              style={{
                background: theme === "dark"
                  ? "rgba(0,0,0,0.4)"
                  : "rgba(0,0,0,0.1)",
                padding: "16px",
                borderRadius: "10px",
                fontSize: "13px",
                whiteSpace: "pre-wrap",
              }}
            >
              {JSON.stringify(data, null, 2)}
            </pre>
          </Card>
        </div>

        {/* FOOTER */}
        <footer
          style={{
            marginTop: "40px",
            opacity: 0.5,
            textAlign: "center",
            fontSize: "13px",
          }}
        >
          Neptune Stack © {new Date().getFullYear()} • DevOps / Kubernetes / SaaS Demo
        </footer>
      </div>
    </>
  );
}

function Card({ title, children, span }) {
  return (
    <div
      style={{
        gridColumn: span ? `span ${span}` : "span 1",
        padding: "24px",
        borderRadius: "16px",
        background: "rgba(255,255,255,0.06)",
        boxShadow: "0 8px 20px rgba(0,0,0,0.4)",
        backdropFilter: "blur(10px)",
      }}
    >
      <h3 style={{ fontSize: "18px", marginBottom: "12px" }}>{title}</h3>
      {children}
    </div>
  );
}

createRoot(document.getElementById("root")).render(<App />);

