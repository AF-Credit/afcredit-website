// ═══════════════════════════════════════════════════════════════
//  AF Credit — Quote Enquiry Handler
//  Google Apps Script Web App
//
//  SETUP:
//  1. Open your Google Sheet → Extensions → Apps Script
//  2. Replace everything with this code and Save
//  3. Run authoriseMe() once manually (▶ button) — approve Gmail access
//  4. Deploy → New deployment → Web app
//     Execute as: Me | Who has access: Anyone
//  5. Copy the Web App URL into get-a-quote.html as APPS_SCRIPT_URL
//
//  AFTER CODE CHANGES: Deploy → Manage deployments → pencil → New version → Deploy
// ═══════════════════════════════════════════════════════════════

var SHEET_NAME   = 'Enquiries';
var NOTIFY_EMAIL = 'enquiries@af.credit';

var HEADERS = [
  'Timestamp',
  'Contact Name',
  'Contact Surname',
  'Borrower Name',
  'Email',
  'Mobile',
  'Borrower Type',
  'UK National?',
  'Main Residence Address',
  'Bad Credit History?',
  'Property Address',
  'Security Type',
  'Transaction Type',
  'Property Value (£)',
  'Purchase Price (£)',
  'Current Debt (£)',
  'Current Lender',
  'Rental Income (£/month)',
  'Net Loan Required (£)',
  'Purpose of Loan',
  'Exit Strategy',
  'Term Required (months)',
  'Desired Completion Date',
  'Refurb — GDV (£)',
  'Refurb — Type',
  'Refurb — Cost of Works (£)',
  '— INDICATIVE QUOTE —',
  'Gross Loan (£)',
  'Monthly Rate (%)',
  'LTV (%)',
  'Net Advance (£)',
  'Notes'
];

// ── Run this ONCE manually before deploying to grant Gmail permission ──
function authoriseMe() {
  GmailApp.sendEmail(
    NOTIFY_EMAIL,
    'AF Credit Apps Script — authorisation confirmed',
    'This script is now authorised to send emails and write to Google Sheets.'
  );
}

function doPost(e) {
  try {
    // Accepts both application/json and text/plain (no-cors workaround)
    var raw  = (e.postData && e.postData.contents) ? e.postData.contents : '{}';
    var data = JSON.parse(raw);

    var ss    = SpreadsheetApp.getActiveSpreadsheet();
    var sheet = ss.getSheetByName(SHEET_NAME);
    if (!sheet) {
      sheet = ss.insertSheet(SHEET_NAME);
    }

    // Write headers on first run
    if (sheet.getLastRow() === 0) {
      sheet.appendRow(HEADERS);
      sheet.getRange(1, 1, 1, HEADERS.length)
           .setFontWeight('bold')
           .setBackground('#1b2b3b')
           .setFontColor('#ffffff');
      sheet.setFrozenRows(1);
    }

    // Append enquiry row
    sheet.appendRow([
      new Date().toLocaleString('en-GB'),
      data.contactName      || '',
      data.contactSurname   || '',
      data.borrowerName     || '',
      data.email            || '',
      data.mobile           || '',
      data.borrowerType     || '',
      data.ukNational       || '',
      data.residenceAddress || '',
      data.badCredit        || '',
      data.propertyAddress  || '',
      data.securityType     || '',
      data.transaction      || '',
      data.propertyValue    || '',
      data.purchasePrice    || '',
      data.currentDebt      || '',
      data.currentLender    || '',
      data.rentalIncome     || '',
      data.netLoan          || '',
      data.purpose          || '',
      data.exitStrategy     || '',
      data.term             || '',
      data.completionDate   || '',
      data.gdv              || '',
      data.refurbType       || '',
      data.costOfWorks      || '',
      '',
      data.quoteGross       || '',
      data.quoteRate        || '',
      data.quoteLtv         || '',
      data.quoteNet         || '',
      data.notes            || ''
    ]);

    // Email notification
    var contactFull = [data.contactName, data.contactSurname].filter(Boolean).join(' ') || data.borrowerName || 'Unknown';
    var subject     = 'New bridging enquiry — ' + contactFull + ' — ' + (data.netLoan || '');
    GmailApp.sendEmail(NOTIFY_EMAIL, subject, buildEmailBody(data), { name: 'AF Credit Enquiries' });

    return ContentService
      .createTextOutput(JSON.stringify({ success: true }))
      .setMimeType(ContentService.MimeType.JSON);

  } catch(err) {
    // Log error to sheet for debugging
    try {
      var ss = SpreadsheetApp.getActiveSpreadsheet();
      var log = ss.getSheetByName('Errors') || ss.insertSheet('Errors');
      log.appendRow([new Date().toLocaleString('en-GB'), err.message, err.stack]);
    } catch(e2) {}

    return ContentService
      .createTextOutput(JSON.stringify({ success: false, error: err.message }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

function buildEmailBody(d) {
  var contactFull = [d.contactName, d.contactSurname].filter(Boolean).join(' ') || '—';
  var lines = [
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    'NEW BRIDGING ENQUIRY — AF Credit',
    '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
    '',
    '── CONTACT ───────────────────────────────',
    'Name:              ' + contactFull,
    'Borrower name:     ' + (d.borrowerName    || '—'),
    'Borrower type:     ' + (d.borrowerType    || '—'),
    'Email:             ' + (d.email           || '—'),
    'Mobile:            ' + (d.mobile          || '—'),
    'UK national:       ' + (d.ukNational      || '—'),
    'Residence:         ' + (d.residenceAddress|| '—'),
    'Bad credit:        ' + (d.badCredit       || '—'),
    '',
    '── PROPERTY ──────────────────────────────',
    'Address:           ' + (d.propertyAddress || '—'),
    'Security type:     ' + (d.securityType    || '—'),
    'Transaction:       ' + (d.transaction     || '—'),
    'Property value:    ' + (d.propertyValue   || '—'),
    'Purchase price:    ' + (d.purchasePrice   || '—'),
    'Current debt:      ' + (d.currentDebt     || '—'),
    'Current lender:    ' + (d.currentLender   || '—'),
    'Rental income:     ' + (d.rentalIncome    || '—'),
    '',
    '── LOAN ──────────────────────────────────',
    'Net loan required: ' + (d.netLoan         || '—'),
    'Purpose:           ' + (d.purpose         || '—'),
    'Exit strategy:     ' + (d.exitStrategy    || '—'),
    'Term:              ' + (d.term            || '—') + ' months',
    'Completion date:   ' + (d.completionDate  || '—')
  ];

  if (d.gdv || d.refurbType || d.costOfWorks) {
    lines = lines.concat([
      '',
      '── REFURBISHMENT ─────────────────────────',
      'GDV:               ' + (d.gdv           || '—'),
      'Refurb type:       ' + (d.refurbType    || '—'),
      'Cost of works:     ' + (d.costOfWorks   || '—')
    ]);
  }

  lines = lines.concat([
    '',
    '── INDICATIVE QUOTE ──────────────────────',
    'Gross loan:        ' + (d.quoteGross      || '—'),
    'Monthly rate:      ' + (d.quoteRate       || '—'),
    'LTV:               ' + (d.quoteLtv        || '—'),
    'Net advance:       ' + (d.quoteNet        || '—')
  ]);

  if (d.notes) {
    lines = lines.concat(['', '── NOTES ─────────────────────────────────', d.notes]);
  }

  lines.push('', '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  return lines.join('\n');
}

// GET handler — use to confirm the script is live
function doGet(e) {
  return ContentService
    .createTextOutput('AF Credit enquiry handler is live. POST to this URL to submit an enquiry.')
    .setMimeType(ContentService.MimeType.TEXT);
}
