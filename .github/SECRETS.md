# GitHub Secrets — Rungroj CarRental

ตั้งค่าที่ GitHub → Settings → Secrets and variables → Actions

## Shared (ทุก environment)
| Secret | คืออะไร |
|--------|---------|
| `SUPABASE_ACCESS_TOKEN` | Personal Access Token จาก supabase.com/dashboard/account/tokens |

## Staging environment
| Secret | ค่า |
|--------|-----|
| `STAGING_SUPABASE_PROJECT_REF` | project ref ของ staging project |
| `STAGING_SUPABASE_URL` | https://[staging-ref].supabase.co |
| `STAGING_SUPABASE_ANON_KEY` | anon key ของ staging |

## Production environment
| Secret | ค่า |
|--------|-----|
| `PROD_SUPABASE_PROJECT_REF` | hkkddlxhcttnejlblmsc |
| `PROD_SUPABASE_URL` | https://hkkddlxhcttnejlblmsc.supabase.co |
| `PROD_SUPABASE_ANON_KEY` | (ดึงจาก Supabase Dashboard > Settings > API) |

## กฎเด็ดขาด
- ห้ามใช้ production key ใน staging
- ห้าม commit ค่า secrets ลง repo
- env.json อยู่ใน .gitignore แล้ว
