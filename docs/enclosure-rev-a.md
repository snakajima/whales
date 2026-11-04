# Compact enclosure mechanical design — Rev A (prototype)

**Status: preliminary CAD concept; not dimensionally verified, waterproof certified, or ready for final electronics installation.** See [OpenSCAD source](../cad/whale_enclosure.scad).

## Requirements
- Hydrophone submerged; electronics remain above water on SUP, but enclosure must survive accidental saltwater immersion.
- Serviceable/repairable lid, no exposed power connectors, Qi charging through plastic, external magnetic OFF/REC/Wi-Fi slider.
- Use the proven 1/4-inch NPT IP68 nylon hydrophone cable gland; actual hole/engagement geometry depends on the *specific gland*.
- Bambu Lab A1 PETG printing, minimal overall size while retaining service access.

## Mechanical envelope
| Parameter | Rev A target |
|---|---:|
| External plan | 130 × 75 mm |
| Overall nominal thickness | 30 mm (24.8 body + 1.2 compressed gasket gap + 4 lid) |
| Body wall / bottom | 3 mm / 3 mm |
| Lid thickness | 4 mm |
| Outside corner radius | 9 mm |
| Interior nominal opening (conservative CAD) | 96 × 41 mm |
| Gasket material | Solid silicone sheet, nominal 1.5 mm, Shore A 40–50 candidate |
| Gasket plan | Rounded rectangular frame, 6 mm wide, nominal 20% compression |
| Screw count | 8 M3 fasteners; actual thread strategy TBD |
| Seal | Flat sheet gasket between PETG mating faces; **no O-ring groove** |

**Fit warning:** the 96 × 41 mm opening is narrower than previously assumed. This Rev A CAD is a sealing-layout mock-up, not proof that the chosen development boards, battery, Qi coil, cable gland and wiring all fit. The gland may be particularly difficult to mount in a 30 mm-high enclosure. If component fit fails, increase the footprint or redesign around a compact custom PCB rather than compromising sealing or battery clearance.

## Seal construction
The silicone sheet is **the gasket**, not an adhesive. Cut a continuous ring from a single sheet using the CAD `gasket_template` 2D outline; no butt splice. Place it between two flat PETG mating lands. The gasket is held by mechanical clamping and a designed stop gap. Use the sheet manufacturer's compression recommendation; 1.5 mm to 1.2 mm (20%) is only a starting assumption. Do not rely on an arbitrary screw torque to set compression.

The OpenSCAD model provides flat seal lands and a nominal gasket opening, but **does not implement compression stops, nut traps, inserts, or cable-gland thread features**. These must be engineered before immersion use. The lid/body stop must control the 1.2 mm closed gap without preventing compression, and remain rigid between fasteners. Fasteners should not pierce the sealed interior. Use a compatible metal insert or captive nut system, verify wall thickness and pull-out resistance, and avoid exposed steel except marine-grade fasteners.

## PETG fabrication
1. Print the body with the opening facing upward; print lid with sealing face on a smooth build plate if geometry permits. Use dry PETG, 4–6 walls, generous top/bottom solid layers, and calibrate dimensional accuracy.
2. Print test coupons to assess water permeation through the wall, especially around perimeters, seams and screw pilots. FDM PETG is not intrinsically watertight.
3. Check sealing-land flatness against a reference flat; lap accessible flat faces on a glass plate using fine wet abrasive if needed. Remove burrs and dust. Do not aggressively sand gasket edges or distort the seal band.
4. If porosity remains, trial a PETG-compatible coating on separate coupons, avoiding uncontrolled buildup on sealing lands and the thin Qi window.
5. Cut gasket with clean, continuous inner/outer edges; avoid nicks, folds and excessive stretching. Replace if damaged after servicing.

## Components and placement constraints
- Hydrophone gland on a short end; **do not cut the gland hole from this generic CAD** until the actual fitting's thread/locknut, panel thickness, wrench access and bend radius are measured. A nominal 1/4-inch NPT is *not* a 1/4-inch-diameter hole.
- Qi receiver near a continuous bottom wall; a local ~1.5–2 mm thinning may be added after measuring coil and charger coupling. Keep ferrite backing as required, metal away from the coil, and test charging temperature.
- Keep ESP32 antenna away from battery, metal screws, wet cable and Qi coil; verify wireless performance on SUP.
- Magnet slider and two Hall sensors should be aligned in an exterior track with no case penetration. Mechanism, retention and wake power circuit are separate design tasks.
- Protected Li-ion battery requires secure mounting, thermal monitoring, charge management and space for swelling; do not rigidly pot the cell.

## Validation and release gates
1. **Dimensional fit:** measure actual PCBs, battery, connectors, cable gland and coil; confirm clearance and assembly path with paper/3D mock-ups.
2. **Mechanical:** lid stiffness, screw pull-out, compression stops, gasket uniformity and repair cycles.
3. **Leak test:** start with an empty/dummy enclosure and water-indicator paper, inspect after repeated submersion (e.g. 1 m/30 min as a practical test, not certification), and after multiple lid opening cycles. Repeat after saltwater exposure, rinse, dry and inspect.
4. **Power/thermal:** measure sealed-box temperatures during recording, Wi-Fi transfer and Qi charging; test thermal cutoffs and power-down WAV finalization.
5. **Field:** secure mounting, positive buoyancy or tether, saltwater resistance, Bluetooth range.

## CAD usage
Open `cad/whale_enclosure.scad` in OpenSCAD and change `part` to `body`, `lid` or `gasket_template`. Render with F6 and export STL (or export the gasket profile as a 2D DXF/SVG after projection). `assembly` is for viewing, not printing. **Do not drill based on the placeholder gland diameter.**

## Next decisions
- Measure the specific ESP32/ADC breakout, 2,000 mAh cell, Qi receiver, and existing gland.
- Decide whether 130 × 75 × 30 mm is actually feasible; if not, adjust dimensions based on measured parts.
- Select silicone sheet specification and calculate/validate compression stops and screw fasteners.
- Build and immerse a dummy enclosure before adding electronics.
