function formatPhone(phoneStr) {
  return phoneStr.replace(/(\d{3})(\d{3})(\d{4})/, "($1) $2-$3");
}