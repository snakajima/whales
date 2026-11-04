# Whale Listener — Hardware Design Notes

Updated: 2026-11-03  
Status: working off-the-shelf prototype; custom-electronics design proposed (not yet validated).

## Purpose
Listen to whale vocalizations live from a stand-up paddleboard (SUP), record audio for up to approximately 30 minutes, and retrieve recordings over Wi-Fi. Only the hydrophone is underwater. The electronics enclosure stays above water during normal use but must survive accidental saltwater submersion.

## Proven prototype
- **Hydrophone:** [Aquarian Audio A5](https://www.aquarianaudio.com/products/a5-hydrophone), underwater.
- **Recorder:** OM SYSTEM / Olympus VN-541PC; A5 connected to its microphone input. This combination works in practice.
- **Bluetooth transmitter:** 3.5 mm analog audio transmitter/receiver marketed as Bluetooth 5.3 with aptX Adaptive / Low Latency and dual-headphone support; exact model unconfirmed. Connected to the recorder's headphone output.
- **Listening:** Waterproof Bluetooth wireless headset (model unspecified).
- **Cable entry:** 1/4-inch NPT IP68 nylon cable gland, already used successfully.
- **Limitation:** Recorder and Bluetooth transmitter cannot be operated externally once sealed.

## Target custom architecture
```text
A5 hydrophone (underwater)
    |
    | cable through IP68 gland
    v
Plug-in-power (PIP) bias + AC coupling / analog front end
    |
Audio ADC / codec --I2S--> ESP32 (original ESP32, Bluetooth Classic)
                             |--> A2DP Source (SBC) --> waterproof headset
                             |--> microSD --> mono WAV files
                             \--> Wi-Fi access point + HTTP file download
```

### Selected design directions
- Use an original **ESP32-WROOM-32E** development board for initial testing. Avoid ESP32-S3 for this design because it lacks Bluetooth Classic A2DP.
- **SBC over Bluetooth A2DP** is acceptable; several hundred milliseconds of latency are tolerable. aptX is not required.
- Record only while offshore, **maximum ~30 minutes** per session.
- Proposed format: **48 kHz, 24-bit, mono WAV**, about **259 MB per 30 minutes** (uncompressed). Validate ADC resolution, sample stability and file handling.
- Use microSD for storage, with an **ESP32-hosted Wi-Fi access point** for later downloads from a phone or PC; no internet needed.
- Prefer Wi-Fi transfer after recording, rather than simultaneous high-throughput Wi-Fi and Bluetooth audio, because both use the ESP32's 2.4 GHz radio.

### Analog audio: engineering work required
- A5 is an **active plug-in-power hydrophone**, not simply a passive piezo sensor.
- Confirm its actual connector wiring, PIP voltage/current, load requirements and output levels from the manufacturer documentation and bench measurements.
- Preserve the satisfactory audio behavior of the existing Olympus recorder.
- Candidate audio ADC: **TLV320ADC3100** or equivalent I2S ADC with accessible evaluation/breakout board. **Not yet selected or verified for purchase.**
- Evaluate low-frequency response, gain, noise and clipping.

## Controls and power
A **three-position external magnetic slider** is proposed:
- **OFF:** finish/close WAV safely, then deep sleep or power-latched shutdown.
- **REC:** start recording and stream audio to Bluetooth headset.
- **Wi-Fi:** start AP and browser-based file transfer.

Two internal micropower Hall sensors can detect the magnet's position without penetrating the case. The sensor arrangement, wake circuit and OFF-state current still require validation. Do not directly disconnect power before finalizing the WAV file.

Proposed power system:
- Protected single-cell Li-ion/LiPo battery (tentatively 1,000–2,000 mAh; size after measurement).
- Qi receiver behind a thin plastic charging window, compatible charging pad.
- Appropriate Li-ion charger with thermal protection/power-path management and regulated ESP32 supply.
- Validate thermal behavior and charging through the final enclosure.

## Enclosure
- Smartphone footprint, thicker body, **3D-printed PETG** (Bambu Lab A1).
- Permanently sealed; no routine opening required.
- Candidate structural walls ~3 mm; locally ~1.5–2 mm at Qi charging window, subject to mechanical and charging tests.
- Candidate bonded tongue-and-groove lid seam. Validate adhesive compatibility with PETG and saltwater.
- FDM prints may leak through layer boundaries; use suitable sealing methods and immersion testing.
- Reuse proven **1/4-inch NPT IP68 nylon cable gland** for hydrophone cable and strain relief.
- Design for accidental submersion, saltwater exposure, corrosion, battery temperature and preferably positive buoyancy.
- **IP68 is a target, not a certified rating.** Avoid rigid potting of the Li-ion battery.

## Preliminary BOM (not a verified shopping cart)
| Item | Qty | Notes |
| --- | ---: | --- |
| ESP32-WROOM-32E development board | 1 | Original ESP32 with Classic Bluetooth |
| I2S audio ADC evaluation/breakout | 1 | TLV320ADC3100 candidate; verify board availability |
| 3.3 V microSD SPI breakout | 1 | Storage interface |
| microSD card, 16 GB | 1 | Ample for 30-minute WAV |
| 3.5 mm TRS socket, passives | Assorted | A5 input/PIP and analog conditioning |
| Breadboard, jumper wires | Assorted | Initial prototype |
| Qi 5 V receiver + Qi pad | 1 each | Confirm coil alignment and gap |
| Li-ion charger with power path, protected cell, regulator | 1 each | Charging and safe supply |
| Micropower Hall sensors | 2 | Magnetic three-mode control |
| Magnets and external slider | Assorted | Mechanism |
| PETG, compatible adhesive/sealant | As needed | Waterproof enclosure |

Earlier rough budget: **$50–90** for audio/logic prototype, **$75–130** for power/enclosure; **$125–220 total**, excluding existing hydrophone/headset, tools, shipping and tax. Not current supplier quotes.

## Implementation milestones
1. Validate A5 PIP electrical interface and audio performance.
2. Stream I2S ADC audio over ESP32 A2DP/SBC to existing headset.
3. Record 30-minute mono WAV to microSD without dropouts; close files reliably.
4. Implement Wi-Fi AP and browser download; verify file integrity.
5. Implement OFF/REC/Wi-Fi magnetic switch and low standby consumption.
6. Integrate battery, charger and Qi receiver; verify heat and charging.
7. Print and seal PETG enclosure; perform repeated leak, immersion and SUP field tests.

## Open questions
- Exact transmitter and headset model (pairing compatibility).
- Final ADC/breakout and analog PIP circuit values.
- Battery sizing from measured current.
- Charging safety in sealed case and robust Hall sensor switching.
- Board mounting, flotation and saltwater durability.
