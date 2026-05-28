# 📚 cheatsheets.dev

> **مستودع واحد. كل ورقة معلومات. دون اتصال بالإنترنت للأبد.**

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
[![Cheatsheets](https://img.shields.io/badge/cheatsheets-100%2B-blue?style=for-the-badge&logo=bookstack)](https://github.com/yourusername/cheatsheets.dev)
[![License](https://img.shields.io/badge/%D8%A7%D9%84%D8%AA%D8%B1%D8%AE%D9%8A%D8%B5-MIT-green?style=for-the-badge)](../../LICENSE)
[![Offline](https://img.shields.io/badge/%D5%A5%D8%B9%D9%85%D9%84-100%25%20%D8%AF%D9%88%D9%86%20%D8%A7%D8%AA%D8%B5%D8%A7%D9%84-orange?style=for-the-badge&logo=wifi)](https://github.com/yourusername/cheatsheets.dev)

</div>

---

## ✨ لماذا هذا المستودع؟

- 🔌 **يعمل 100% دون اتصال** — انسخ المستودع مرة واحدة، وابحث للأبد.
- 🚫 **لا إعلانات، لا تعقب، لا جدران دفع** — بيانات برمجية نقية ومباشرة بدون تعقيد.
- 🌍 **للجميع** — المطورين، مهندسي DevOps، اللاعبين، مجمعي الأجهزة، والطلاب.

---

## 📂 فهرس الأقسام

| القسم | عدد أوراق المعلومات | الوصف |
|---|---|---|
| 🖥️ [Dev](../../dev/) | 30 | اللغات، بيئات العمل، قواعد البيانات، الواجهات |
| 🚀 [DevOps](../../devops/) | 10 | الحاويات، خوادم الويب، الشبكات، أدوات النشر |
| 🎮 [Gaming](../../gaming/) | 5 | تهيئة النظام، الأداء، خيارات التشغيل، حلول المشاكل |
| 🔧 [Hardware](../../hardware/) | 5 | التجميع، BIOS، كسر سرعة الذاكرة، التبريد |

---

## ⚡ البداية السريعة

```bash
# نسخ المستودع
git clone https://github.com/yourusername/cheatsheets.dev
cd cheatsheets.dev

# تفعيل صلاحيات تشغيل ملف البحث
chmod +x search.sh

# ابحث عن أي موضوع فوراً
./search.sh "docker stop"
```

> **لا توجد تبعيات مطلوبة.** أداة [fzf](https://github.com/junegunn/fzf) اختيارية ولكنها تفتح ميزة البحث التفاعلي الفزي.

---

## 🖥️ تطبيق الويب التفاعلي (مستندات Localhost)

لتجربة رسومية ممتازة وتفاعلية وفهم أسرع، تحقق من تطبيق الويب الاستاتيكي المدمج:

```bash
# ابدأ خادم ويب محلي بسيط في جذر المستودع
python -m http.server 8000
```

ثم افتح متصفحك وانتقل إلى:
👉 **`http://localhost:8000/docs/`**

**ميزات عرض Localhost:**
- 🔍 **البحث الفوري:** بحث فوري ذكي مع تمييز مرئي للنتائج (`<mark>`).
- 🗂️ **تصنيفات تفاعلية:** تصفية أوراق المعلومات بشكل ديناميكي حسب الفئة (المطورين، DevOps، الألعاب، والأجهزة).
- 🔮 **نافذة عرض ذكية:** تفتح وتعرض أوراق markdown في نافذة مدمجة وشفافة فائقة الجمال دون أي إعادة تحميل للصفحات.
- 📋 **نسخ إلى الحافظة:** أزرار نسخ بضغطة واحدة لجميع كتل الأكواد البرمجية.
- 📴 **آمن 100% دون اتصال:** يعمل بشكل كامل دون أي اتصال نشط بالإنترنت.

---

## 📴 كيف تستخدمه دون اتصال

انسخ المستودع مرة واحدة وستكون جاهزاً — كل ورقة معلومات عبارة عن ملف Markdown بسيط يتم عرضه بشكل جميل في أي محرر أو طرفية. افتح الملفات مباشرة، أو استخدم `./search.sh` أو تصفح عبر [Obsidian](https://obsidian.md/) أو [Typora](https://typora.io/) أو VS Code.

---

## 🔍 ديمو للبحث

```
$ ./search.sh "docker remove"

 ─────────────────────────────────────────────────────────────
  🔍  cheatsheets.dev — البحث دون اتصال
 ─────────────────────────────────────────────────────────────

  تم العثور على 3 تطابق(ات) لـ "docker remove" في ملفين:

  📄 devops/docker.md
     السطر  87 │ docker rm <container>           # حذف حاوية متوقفة
     السطر  88 │ docker rm -f <container>         # حذف حاوية تعمل بالقوة

  📄 devops/kubernetes.md
     السطر 204 │ kubectl delete pod <name>         # حذف pod

 ─────────────────────────────────────────────────────────────
  نصيحة: شغل ./search.sh --list لعرض كافة الأوراق المتاحة
 ─────────────────────────────────────────────────────────────
```

---

## 🚀 المميزات

| الميزة | التفاصيل |
|---|---|
| 🔌 **100% دون اتصال** | انسخ مرة واحدة، واعمل للأبد دون اتصال بالإنترنت |
| 🔍 **البحث الكامل** | `./search.sh <query>` — بحث فوري باستخدام grep + fzf |
| 📋 **تنسيق موحد** | تستخدم كل ورقة نفس النموذج المعتمد [TEMPLATE.md](../../TEMPLATE.md) |
| ✅ **أوامر مجربة** | تم اختبار جميع الأوامر ووضع علامة على تاريخ آخر تحقق |
| 🤝 **مساهمة مجتمعية** | نرحب بفتح المساهمات — يتم دمجها في غضون 24 ساعة |

---

## 🤝 كيف تساهم معنا

نرحب بجميع المساهمات بمختلف أحجامها!

1. اقرأ [دليل المساهمة (CONTRIBUTING.md)](../../CONTRIBUTING.md) — يستغرق 5 دقائق فقط.
2. انسخ النموذج [TEMPLATE.md](../../TEMPLATE.md) إلى مجلد الفئة الصحيح.
3. املأه بأوامر دقيقة ومجربة.
4. افتح PR بالعنوان: `Add: [tool name] cheatsheet`

---

## 📜 الترخيص

MIT © 2026 [المساهمون في cheatsheets.dev](https://github.com/yourusername/cheatsheets.dev/graphs/contributors)

راجع [LICENSE](../../LICENSE) للشروط الكاملة.

---

<div align="center">

**صُنع خصيصاً للمطورين، اللاعبين، ومحترفي الأجهزة — في كل مكان، دون اتصال، وللأبد.**

</div>
