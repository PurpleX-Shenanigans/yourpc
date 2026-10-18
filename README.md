# 🖥️ yourpc

> *Because JioPC sucks, and we deserve better free cloud desktop environments.*

`yourpc` is a lightweight, disposable, containerized Linux desktop (KDE Plasma) that runs seamlessly inside GitHub Codespaces and streams directly to your browser over secure Cloudflare Tunnels.

---

## ⚡ Quick Start Guide

Follow these simple steps to spin up your browser-based Cloud PC in under 2 minutes:

1. **Sign Up / Log In**  
   Make sure you have an active [GitHub account](https://github.com).

2. **Fork the Repository**  
   Fork this repository to your own account by clicking the **Fork** button at the top right (or rename it to whatever you like).

3. **Launch Codespace**  
   In your forked repository:
   * Click the green **Code** button.
   * Switch to the **Codespaces** tab.
   * Click **Create codespace on main**.

4. **Initialize Container**  
   Wait a minute for GitHub Codespaces to finish building the environment container.

5. **Start Desktop Session**  
   Open the VS Code terminal inside Codespaces and run:
   ```bash
   ./desktop.sh
   ```

6. **Connect via Cloudflare**  
   * Wait for the script execution to output the generated `https://xxxx.trycloudflare.com` URL.
   * Open the link in any web browser and log in with the default credentials:
     * **Username:** `cloudpc`
     * **Password:** `in-isthebest`

---

## 📌 Important Notes

* **Disposable Workspaces:** This is an ephemeral, throwaway environment. No state or file progress is saved once the Codespace is shut down or deleted.
* **Inactivity Shutdowns:** GitHub Codespaces automatically puts idle environments to sleep after a period of inactivity.

---

## 🤝 Contributing

Found a bug or figured out a reliable trick to keep GitHub Codespaces awake longer? 

Pull requests and contributions are welcome! Feel free to open an issue or submit a PR to help improve `yourpc`.
