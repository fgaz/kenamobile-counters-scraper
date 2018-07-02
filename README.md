# kenamobile-counters-scraper

**Scraper for kenamobile's "mykena" user dashboard.**

## Usage

```
USAGE:
  ./kenascraper.sh PHONENUMBER PASSWORD ACTION
  Where ACTION is one of: get_available_options get_customer_info get_promo_counters get_credit_info get_invoice get_services get_sim_info
```

## Example

```bash
$ ./kenascraper.sh myphonenumber mypassword get_promo_counters | jq
```
results in
```json
[
  {
    "activable_by_user": 1,
    "startDate": "25/06/2018 14:04:01",
    "endDate": "25/07/2018 14:04:01",
    "promoName": "KENA POWER",
    "name": "MOBILE_KENA_POWER",
    "subscriptionStatus": 1,
    "translated_fields": {
      "title": "Kena Power",
      "description": "1.000, 50 SMS e 20GB a 5€ al mese",
      "short_description": "Kena Power",
      "description_tooltip": "1.000 minuti a secondi di conversazione verso tutti i fissi e mobili, 50 SMS verso tutti e 20GB a 5€ ogni mese. L'Offerta  si rinnova automaticamente se Il credito sulla SIM è sufficiente. Se esaurisci minuti o SMS prima del termine del mese e in assenza di Opzioni aggiuntive attive, si applicano i costi del Piano Base Kena. Se esaurisci i GB, il traffico dati viene bloccato; per continuare a navigare con il Piano Base Kena o per utilizzare l'Opzione dati aggiuntiva, se attiva, devi inviare un SMS al 40543711 con testo INTERNET ON.  Minuti, SMS e GB (fino a max 1,5 GB) sono utilizzabili anche  in Zona UE. L'Offerta  è a tempo indeterminato salvo disattivazione gratuita. Gli SMS e i GB inclusi nell'Offerta sono utilizzabili solo se il credito della SIM è superiore a zero.",
      "price": "5€ al mese"
    },
    "auxBag": {
      "3": {
        "name": "Dati UE",
        "value": 1.5,
        "unit": "GB",
        "base_value": 1610612736,
        "bagInitValue": 1610612736
      },
      "2": {
        "name": "Dati complessivi",
        "value": 19.759,
        "unit": "GB",
        "base_value": 21216060416,
        "bagInitValue": 21474836480
      },
      "4": {
        "name": "SMS verso tutti",
        "value": 49,
        "unit": "SMS",
        "base_value": 49,
        "bagInitValue": 50
      },
      "0": {
        "name": "Voce verso Tutti",
        "value": 998,
        "unit": "minuti",
        "base_value": 59894,
        "bagInitValue": 60000
      }
    }
  }
]
```

You can use `jq` to get only the information you need. For example:

* Only counters: `jq '.[0].auxBag'`
* Remaining megabytes: `jq '.[0].auxBag."2"|(.base_value / 1000000)'`
* Remaining fraction of mobile data: `jq '.[0].auxBag."2"|(.base_value / .bagInitValue)'`

