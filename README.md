# FULL DUPLEX UART (Universal Asynchronous Receiver Transmitter)

## 📖 Overview
UART (Universal Asynchronous Receiver Transmitter) is a widely used serial communication protocol.  
It enables data transfer between devices **bit by bit** over two main lines:  

- **TX (Transmit)** → Sends data  
- **RX (Receive)** → Receives data  

Unlike SPI or I²C, UART is **asynchronous**, meaning no separate clock line is required.  
Both transmitter and receiver must be configured with the **same baud rate** (bits per second).

---

## ⚡ UART Transmitter
The **transmitter** converts parallel data (e.g., an 8-bit character) into serial form.  

The output data frame in this design consists of:  
- **Start bit** (always `0`)  
- **Data bits** (8 bits, LSB first)  
- **Stop bit** (always `1`)  

### 🖼 Transmitter Output Waveform

<img width="1358" height="515" alt="Tx_2states_waveform" src="https://github.com/user-attachments/assets/c8b7d632-6ae7-4c52-99bc-9d19047ca804" />


---

## ⚡ UART Receiver
The **receiver** listens to the RX line, detects the **start bit**, and samples each bit at the given baud rate.  
It reconstructs the original parallel data once all 8 data bits are received.  

### 🖼 Example Receiver Output Waveform

![Rx](https://github.com/user-attachments/assets/f5356081-ab33-4afb-9cea-9bbdfb7ffaeb)

---




