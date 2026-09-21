# 📚 cheatsheets.dev (v2.0)

> **مستودع واحد. كل ورقة معلومات مرجعية. أوامر حقيقية لبيئات الإنتاج. دون اتصال بالإنترنت للأبد.**

<p align="center">
  🌐
  <a href="../../README.md">English</a> |
  <a href="../es/README.md">Español</a> |
  <a href="../hi/README.md">हिन्दी</a> |
  <a href="../pt/README.md">Português</a> |
  <a href="../zh/README.md">简体中文</a> |
  <a href="README.md">العربية</a>
</p>

<div align="center">

[![Stars](https://img.shields.io/github/stars/yourusername/cheatsheets.dev?style=for-the-badge&logo=github&color=FFD700)](https://github.com/yourusername/cheatsheets.dev/stargazers)
[![Contributors](https://img.shields.io/github/contributors/yourusername/cheatsheets.dev?style=for-the-badge&logo=github&color=4CAF50)](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)
[![Cheatsheets](https://img.shields.io/badge/cheatsheets-74%20%D8%AF%D9%84%D9%8A%D9%84-blue?style=for-the-badge&logo=bookstack)](https://github.com/yourusername/cheatsheets.dev)
[![License](https://img.shields.io/badge/%D8%A7%D9%84%D8%AA%D8%B1%D8%AE%D9%8A%D8%B5-MIT-green?style=for-the-badge)](../../LICENSE)
[![Offline](https://img.shields.io/badge/%D9%8A%D8%B9%D9%85%D9%84-100%25%20%D8%AF%D9%88%D9%86%20%D8%A7%D8%AA%D8%B5%D8%A7%D9%84-orange?style=for-the-badge&logo=wifi)](https://github.com/yourusername/cheatsheets.dev)

</div>

---

## ✨ لماذا هذا المستودع؟

- 🔌 **يعمل 100% دون اتصال بالإنترنت** — انسخ المستودع مرة واحدة، وابحث للأبد دون الحاجة لأي اتصال بالشبكة.
- 🚫 **خالٍ من الإعلانات والتتبع وبوابات الدفع** — أوامر حقيقية ومجربة عملياً دون أي محتوى اصطناعي وهمي.
- 🌍 **موجّه للجميع** — مطورو البرمجيات، مهندسو DevOps، باحثو الذكاء الاصطناعي وتعلم الآلة، مهندسو الأنظمة، فنيو دعم تكنولوجيا المعلومات، مجمّعو الحواسيب، وهواة الألعاب.
- 🛡️ **أدلة التعافي من الكوارث وحالات الانهيار** — خطوات تفصيلية لتشخيص وحل انهيارات الخوادم، هجمات برامج الفدية، نفاد الذاكرة OOM، تعطل الإقلاع، وانقطاع الشبكات.

---

## 📂 فهرس الأقسام (74 دليلاً مرجعياً شاملاً)

| القسم | العدد | التركيز وموضوعات بيئات العمل والإنتاج |
|---|:---:|---|
| 🖥️ [تطوير البرمجيات (Dev)](../../dev/) | 30 | Git، Bash، Vim، Docker، SQL، Python، JS، TS، Go، Rust، C++، Regex، HTTP، أوامر Linux، JSON/YAML، إلخ |
| 🚀 [العمليات والتكامل (DevOps)](../../devops/) | 10 | Kubernetes (`kubectl`)، Terraform، GitHub Actions، systemd، iptables، Prometheus، Ansible، واجهات AWS/GCP/Azure |
| 🎮 [تحسين الألعاب (Gaming)](../../gaming/) | 5 | تحسين أداء الحاسوب، المحاكيات، إزالة برمجيات ويندوز الزائدة، وضع الألعاب، تقليل زمن الاستجابة |
| 🔧 [العتاد الصلب (Hardware)](../../hardware/) | 5 | إعدادات BIOS، كسر سرعة الرام وتوقيتاتها، فحص سلامة أقراص SSD/NVMe، المعجون والتبريد الحراري، قائمة تجميع الحواسيب |
| 🤖 [الذكاء الاصطناعي (AI & ML)](../../ai-ml/) | 8 | PyTorch، TensorFlow، HuggingFace، الضبط الدقيق للنماذج (LoRA/QLoRA)، تشغيل النماذج محلياً (vLLM/Ollama)، استرجاع RAG وقواعد البيانات المتجهة، استكشاف أخطاء CUDA والبطاقات الرسومية، تقييم النماذج وMLOps |
| ⚙️ [هندسة الأنظمة (Systems)](../../systems/) | 8 | ضبط نواة لينكس، تصحيح الأداء عبر eBPF وPerf، أنظمة ملفات ZFS وBtrfs، عناقيد التوافرية العالية (Pacemaker/Corosync)، التحصين الأمني للمؤسسات، المحاكاة الافتراضية عبر KVM/Proxmox، التخزين الموزع Ceph، التعافي من برمجيات الفدية |
| 🛠️ [دعم تقنية المعلومات (IT Support)](../../it-support/) | 8 | التعافي من كوارث ويندوز (شاشة الموت الزرقاء BSOD/WinRE)، إنقاذ نظام macOS، إنقاذ الشبكات وتشخيص الحزم، دليل Active Directory وإدارة الهوية، استعادة البيانات والتحقيق الرقمي الجنائي، الاستجابة للحوادث السيبرانية، تشخيص الطابعات والملحقات، مخططات تشخيص أعطال العتاد |

---

## ⚡ البداية السريعة

```bash
# نسخ المستودع
git clone https://github.com/yourusername/cheatsheets.dev
cd cheatsheets.dev/version2

# تفعيل صلاحيات التشغيل لملف البحث (Linux/macOS)
chmod +x search.sh

# ابحث فوراً في كافة الأدلة الـ 74 المتاحة
./search.sh "cuda oom"
```

> **لا توجد تبعيات إضافية مطلوبة.** استخدام أداة [fzf](https://github.com/junegunn/fzf) اختياري لتفعيل البحث التفاعلي الفزي.

---

## 🖥️ تطبيق الويب التفاعلي (مستندات Localhost)

لتجربة رسومية تفاعلية سريعة تتيح تصفح وقراءة كافة الأدلة وتنسيق Markdown فورياً، شغل خادم المستندات المحلي المدمج:

```bash
# تشغيل خادم محلي خفيف في مجلد version2
python -m http.server 8000
```

ثم افتح المتصفح وانتقل إلى:
👉 **`http://localhost:8000/docs/`**

**مميزات قارئ المستندات المحلي:**
- 🔍 **بحث فوري ومباشر:** تصفية فورية حسب الكلمات المفتاحية مع تظليل النتائج المطابقة (`<mark>`).
- 🗂️ **7 علامات تبويب للتصفية:** التبديل الفوري بين الكل (74)، التطوير (30)، العمليات (10)، الألعاب (5)، العتاد (5)، الذكاء الاصطناعي (8)، الأنظمة (8)، والدعم الفني (8).
- 🔮 **نافذة عرض بتأثير الزجاج الشفاف:** قراءة أوراق المعلومات بسلاسة فائقة دون الحاجة لتحديث الصفحة.
- 📋 **نسخ الكود بنقرة واحدة:** زر مخصص لنسخ الأوامر والإعدادات بسرعة وسهولة.
- 📴 **آمن 100% دون إنترنت:** واجهة محلية نقية دون أي اعتماد على مكتبات أو روابط CDN خارجية.

---

## 📴 الاستخدام دون اتصال بالإنترنت

يكفي نسخ المستودع مرة واحدة: كل ورقة معلومات هي ملف Markdown عادي يظهر بأفضل شكل في سطر الأوامر أو أي محرر نصوص مثل [Obsidian](https://obsidian.md/) أو [Typora](https://typora.io/) أو VS Code.

---

## 🔍 تجربة البحث في الطرفية

```
$ ./search.sh "cuda oom"

 ─────────────────────────────────────────────────────────────
  🔍  cheatsheets.dev (v2.0) — بحث دون اتصال
 ─────────────────────────────────────────────────────────────

  تم العثور على 4 نتائج لعبارة "cuda oom" عبر ملفين:

  📄 ai-ml/cuda-gpu-troubleshooting.md
     Line  84 │ export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
     Line  89 │ torch.cuda.empty_cache(); gc.collect()

  📄 ai-ml/pytorch.md
     Line 142 │ with torch.no_grad(): output = model(inputs)

 ─────────────────────────────────────────────────────────────
  نصيحة: شغّل الأمر ./search.sh --list لعرض جميع الأدلة الـ 74 المتوفرة
 ─────────────────────────────────────────────────────────────
```

---

## 🚀 المميزات الرئيسية

| الميزة | التفاصيل |
|---|---|
| 🔌 **100% دون اتصال** | يعمل دائماً وبشكل كامل دون الحاجة لأي اتصال بالإنترنت |
| 🔍 **بحث سريع في الطرفية** | `./search.sh <الكلمة>` — بحث نصي عبر grep مع تكامل fzf |
| 🖥️ **تطبيق ويب تفاعلي** | واجهة ويب متكاملة في مجلد `docs/` دون أي تبعيات برمجية |
| 📋 **تنسيق موحد ودقيق** | جميع الأدلة تتبع المعيار الرسمي في [TEMPLATE.md](TEMPLATE.md) |
| ✅ **أوامر حقيقية وموثوقة** | أوامر عملية تم اختبارها لبيئات الإنتاج وحالات الإنقاذ الطارئة |
| 🌍 **دعم متعدد اللغات** | ملفات README متكاملة ومترجمة بدقة عبر 6 لغات رئيسية |
| 🤝 **مشروع مفتوح المصدر** | مرخص بموجب رخصة MIT ومتاح للمساهمات والتطوير المستمر |

---

## 🤝 كيفية المساهمة

نرحب بجميع مساهمات المجتمع التقني!

1. اقرأ دليل المساهمة [CONTRIBUTING.md](CONTRIBUTING.md) — يستغرق أقل من 5 دقائق.
2. انسخ القالب [TEMPLATE.md](TEMPLATE.md) إلى مجلد القسم المناسب.
3. اكتب أوامر حقيقية ومختبرة مدعومة بأمثلة عملية وشروحات واضحة.
4. أرسل Pull Request بعنوان: `Add: [اسم الأداة] cheatsheet`

---

## 📜 الترخيص

حقوق النشر MIT © 2026 [مساهمو cheatsheets.dev](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)

راجع ملف [LICENSE](LICENSE) للاطلاع على البنود القانونية الكاملة.

---

<div align="center">

**صُمم للمطورين، مهندسي DevOps، باحثي الذكاء الاصطناعي، مديري الأنظمة وفنيي الدعم — في كل مكان، دون اتصال، للأبد.**

</div>
