import json
import os
import sys

def apply_updates(patch_file_path):
    if not os.path.exists(patch_file_path):
        print(f"Hata: Patch dosyasi bulunamadi: {patch_file_path}")
        sys.exit(1)

    with open(patch_file_path, 'r', encoding='utf-8') as f:
        patch_data = json.load(f)

    target_root = patch_data.get("target_root", r"C:\Users\forma\Desktop\Projects\english_acquisition_app_current")
    changes = patch_data.get("changes", [])

    print(f"=== ENGLISH ACQUISITION APP UPDATER ===")
    print(f"Hedef Dizin: {target_root}")
    print(f"Uygulanacak Degisiklik Sayisi: {len(changes)}\n")

    for change in changes:
        rel_path = change["path"]
        content = change["content"]
        action = change.get("action", "write")
        full_path = os.path.join(target_root, rel_path)

        os.makedirs(os.path.dirname(full_path), exist_ok=True)

        if action == "write":
            with open(full_path, 'w', encoding='utf-8') as out_f:
                out_f.write(content)
            print(f"[GUNCELENDI/OLUSTURULDU] {rel_path}")
        elif action == "delete":
            if os.path.exists(full_path):
                os.remove(full_path)
                print(f"[SILINDI] {rel_path}")

    print("\n[BASARILI] Tum kod degisiklikleri hedef projeye uygulandi.")

if __name__ == "__main__":
    patch_path = sys.argv[1] if len(sys.argv) > 1 else "patch.json"
    apply_updates(patch_path)