import os

prompt_file = "AI_English_Reflex_Coach_Copilot_Master_Prompt_TR_v7_TWO_USER_WINDOWS_PERSONAL.txt"
sources_file = "english_acquisition_app_current_sources_utf8.txt"

def load_context():
    print("--- BAĞLAM YÜKLENİYOR ---")
    with open(prompt_file, "r", encoding="utf-8") as f:
        prompt_content = f.read()
    
    with open(sources_file, "r", encoding="utf-8") as f:
        sources_content = f.read()
        
    print(f"[BAŞARILI] Prompt ve {len(sources_content)} karakterlik kaynak kod hafızaya alındı.")
    return prompt_content, sources_content

if __name__ == "__main__":
    p, s = load_context()
    print("Sistem analize ve kod düzeltme turuna hazır!")