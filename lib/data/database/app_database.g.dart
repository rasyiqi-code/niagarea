// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SiklusTableTable extends SiklusTable
    with TableInfo<$SiklusTableTable, Siklus> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SiklusTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _namaSiklusMeta = const VerificationMeta(
    'namaSiklus',
  );
  @override
  late final GeneratedColumn<String> namaSiklus = GeneratedColumn<String>(
    'nama_siklus',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modalSetorMeta = const VerificationMeta(
    'modalSetor',
  );
  @override
  late final GeneratedColumn<int> modalSetor = GeneratedColumn<int>(
    'modal_setor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _biayaAdminMeta = const VerificationMeta(
    'biayaAdmin',
  );
  @override
  late final GeneratedColumn<int> biayaAdmin = GeneratedColumn<int>(
    'biaya_admin',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _biayaTransaksiMeta = const VerificationMeta(
    'biayaTransaksi',
  );
  @override
  late final GeneratedColumn<int> biayaTransaksi = GeneratedColumn<int>(
    'biaya_transaksi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _saldoMasukMeta = const VerificationMeta(
    'saldoMasuk',
  );
  @override
  late final GeneratedColumn<int> saldoMasuk = GeneratedColumn<int>(
    'saldo_masuk',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saldoSisaMeta = const VerificationMeta(
    'saldoSisa',
  );
  @override
  late final GeneratedColumn<int> saldoSisa = GeneratedColumn<int>(
    'saldo_sisa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tanggalMulaiMeta = const VerificationMeta(
    'tanggalMulai',
  );
  @override
  late final GeneratedColumn<DateTime> tanggalMulai = GeneratedColumn<DateTime>(
    'tanggal_mulai',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _tanggalSelesaiMeta = const VerificationMeta(
    'tanggalSelesai',
  );
  @override
  late final GeneratedColumn<DateTime> tanggalSelesai =
      GeneratedColumn<DateTime>(
        'tanggal_selesai',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('aktif'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    namaSiklus,
    modalSetor,
    biayaAdmin,
    biayaTransaksi,
    saldoMasuk,
    saldoSisa,
    tanggalMulai,
    tanggalSelesai,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'siklus';
  @override
  VerificationContext validateIntegrity(
    Insertable<Siklus> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nama_siklus')) {
      context.handle(
        _namaSiklusMeta,
        namaSiklus.isAcceptableOrUnknown(data['nama_siklus']!, _namaSiklusMeta),
      );
    } else if (isInserting) {
      context.missing(_namaSiklusMeta);
    }
    if (data.containsKey('modal_setor')) {
      context.handle(
        _modalSetorMeta,
        modalSetor.isAcceptableOrUnknown(data['modal_setor']!, _modalSetorMeta),
      );
    } else if (isInserting) {
      context.missing(_modalSetorMeta);
    }
    if (data.containsKey('biaya_admin')) {
      context.handle(
        _biayaAdminMeta,
        biayaAdmin.isAcceptableOrUnknown(data['biaya_admin']!, _biayaAdminMeta),
      );
    }
    if (data.containsKey('biaya_transaksi')) {
      context.handle(
        _biayaTransaksiMeta,
        biayaTransaksi.isAcceptableOrUnknown(
          data['biaya_transaksi']!,
          _biayaTransaksiMeta,
        ),
      );
    }
    if (data.containsKey('saldo_masuk')) {
      context.handle(
        _saldoMasukMeta,
        saldoMasuk.isAcceptableOrUnknown(data['saldo_masuk']!, _saldoMasukMeta),
      );
    } else if (isInserting) {
      context.missing(_saldoMasukMeta);
    }
    if (data.containsKey('saldo_sisa')) {
      context.handle(
        _saldoSisaMeta,
        saldoSisa.isAcceptableOrUnknown(data['saldo_sisa']!, _saldoSisaMeta),
      );
    } else if (isInserting) {
      context.missing(_saldoSisaMeta);
    }
    if (data.containsKey('tanggal_mulai')) {
      context.handle(
        _tanggalMulaiMeta,
        tanggalMulai.isAcceptableOrUnknown(
          data['tanggal_mulai']!,
          _tanggalMulaiMeta,
        ),
      );
    }
    if (data.containsKey('tanggal_selesai')) {
      context.handle(
        _tanggalSelesaiMeta,
        tanggalSelesai.isAcceptableOrUnknown(
          data['tanggal_selesai']!,
          _tanggalSelesaiMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Siklus map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Siklus(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      namaSiklus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_siklus'],
      )!,
      modalSetor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}modal_setor'],
      )!,
      biayaAdmin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}biaya_admin'],
      )!,
      biayaTransaksi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}biaya_transaksi'],
      )!,
      saldoMasuk: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saldo_masuk'],
      )!,
      saldoSisa: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saldo_sisa'],
      )!,
      tanggalMulai: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal_mulai'],
      )!,
      tanggalSelesai: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal_selesai'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $SiklusTableTable createAlias(String alias) {
    return $SiklusTableTable(attachedDatabase, alias);
  }
}

class Siklus extends DataClass implements Insertable<Siklus> {
  /// ID auto-increment
  final int id;

  /// Nama/label siklus, misal "Top-up April 2026"
  final String namaSiklus;

  /// Uang yang ditransfer ke Digiflazz (dalam Rupiah)
  final int modalSetor;

  /// Potongan dari provider/Digiflazz (dalam Rupiah)
  final int biayaAdmin;

  /// Potongan metode pembayaran: QRIS, transfer, dll (dalam Rupiah)
  final int biayaTransaksi;

  /// Saldo bersih yang masuk = modal_setor - biaya_admin - biaya_transaksi
  final int saldoMasuk;

  /// Sisa saldo dari siklus ini (berkurang setiap transaksi FIFO)
  final int saldoSisa;

  /// Tanggal mulai siklus (waktu deposit)
  final DateTime tanggalMulai;

  /// Tanggal selesai (saat saldo habis), nullable
  final DateTime? tanggalSelesai;

  /// Status siklus: 'aktif' atau 'selesai'
  final String status;
  const Siklus({
    required this.id,
    required this.namaSiklus,
    required this.modalSetor,
    required this.biayaAdmin,
    required this.biayaTransaksi,
    required this.saldoMasuk,
    required this.saldoSisa,
    required this.tanggalMulai,
    this.tanggalSelesai,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nama_siklus'] = Variable<String>(namaSiklus);
    map['modal_setor'] = Variable<int>(modalSetor);
    map['biaya_admin'] = Variable<int>(biayaAdmin);
    map['biaya_transaksi'] = Variable<int>(biayaTransaksi);
    map['saldo_masuk'] = Variable<int>(saldoMasuk);
    map['saldo_sisa'] = Variable<int>(saldoSisa);
    map['tanggal_mulai'] = Variable<DateTime>(tanggalMulai);
    if (!nullToAbsent || tanggalSelesai != null) {
      map['tanggal_selesai'] = Variable<DateTime>(tanggalSelesai);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  SiklusTableCompanion toCompanion(bool nullToAbsent) {
    return SiklusTableCompanion(
      id: Value(id),
      namaSiklus: Value(namaSiklus),
      modalSetor: Value(modalSetor),
      biayaAdmin: Value(biayaAdmin),
      biayaTransaksi: Value(biayaTransaksi),
      saldoMasuk: Value(saldoMasuk),
      saldoSisa: Value(saldoSisa),
      tanggalMulai: Value(tanggalMulai),
      tanggalSelesai: tanggalSelesai == null && nullToAbsent
          ? const Value.absent()
          : Value(tanggalSelesai),
      status: Value(status),
    );
  }

  factory Siklus.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Siklus(
      id: serializer.fromJson<int>(json['id']),
      namaSiklus: serializer.fromJson<String>(json['namaSiklus']),
      modalSetor: serializer.fromJson<int>(json['modalSetor']),
      biayaAdmin: serializer.fromJson<int>(json['biayaAdmin']),
      biayaTransaksi: serializer.fromJson<int>(json['biayaTransaksi']),
      saldoMasuk: serializer.fromJson<int>(json['saldoMasuk']),
      saldoSisa: serializer.fromJson<int>(json['saldoSisa']),
      tanggalMulai: serializer.fromJson<DateTime>(json['tanggalMulai']),
      tanggalSelesai: serializer.fromJson<DateTime?>(json['tanggalSelesai']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'namaSiklus': serializer.toJson<String>(namaSiklus),
      'modalSetor': serializer.toJson<int>(modalSetor),
      'biayaAdmin': serializer.toJson<int>(biayaAdmin),
      'biayaTransaksi': serializer.toJson<int>(biayaTransaksi),
      'saldoMasuk': serializer.toJson<int>(saldoMasuk),
      'saldoSisa': serializer.toJson<int>(saldoSisa),
      'tanggalMulai': serializer.toJson<DateTime>(tanggalMulai),
      'tanggalSelesai': serializer.toJson<DateTime?>(tanggalSelesai),
      'status': serializer.toJson<String>(status),
    };
  }

  Siklus copyWith({
    int? id,
    String? namaSiklus,
    int? modalSetor,
    int? biayaAdmin,
    int? biayaTransaksi,
    int? saldoMasuk,
    int? saldoSisa,
    DateTime? tanggalMulai,
    Value<DateTime?> tanggalSelesai = const Value.absent(),
    String? status,
  }) => Siklus(
    id: id ?? this.id,
    namaSiklus: namaSiklus ?? this.namaSiklus,
    modalSetor: modalSetor ?? this.modalSetor,
    biayaAdmin: biayaAdmin ?? this.biayaAdmin,
    biayaTransaksi: biayaTransaksi ?? this.biayaTransaksi,
    saldoMasuk: saldoMasuk ?? this.saldoMasuk,
    saldoSisa: saldoSisa ?? this.saldoSisa,
    tanggalMulai: tanggalMulai ?? this.tanggalMulai,
    tanggalSelesai: tanggalSelesai.present
        ? tanggalSelesai.value
        : this.tanggalSelesai,
    status: status ?? this.status,
  );
  Siklus copyWithCompanion(SiklusTableCompanion data) {
    return Siklus(
      id: data.id.present ? data.id.value : this.id,
      namaSiklus: data.namaSiklus.present
          ? data.namaSiklus.value
          : this.namaSiklus,
      modalSetor: data.modalSetor.present
          ? data.modalSetor.value
          : this.modalSetor,
      biayaAdmin: data.biayaAdmin.present
          ? data.biayaAdmin.value
          : this.biayaAdmin,
      biayaTransaksi: data.biayaTransaksi.present
          ? data.biayaTransaksi.value
          : this.biayaTransaksi,
      saldoMasuk: data.saldoMasuk.present
          ? data.saldoMasuk.value
          : this.saldoMasuk,
      saldoSisa: data.saldoSisa.present ? data.saldoSisa.value : this.saldoSisa,
      tanggalMulai: data.tanggalMulai.present
          ? data.tanggalMulai.value
          : this.tanggalMulai,
      tanggalSelesai: data.tanggalSelesai.present
          ? data.tanggalSelesai.value
          : this.tanggalSelesai,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Siklus(')
          ..write('id: $id, ')
          ..write('namaSiklus: $namaSiklus, ')
          ..write('modalSetor: $modalSetor, ')
          ..write('biayaAdmin: $biayaAdmin, ')
          ..write('biayaTransaksi: $biayaTransaksi, ')
          ..write('saldoMasuk: $saldoMasuk, ')
          ..write('saldoSisa: $saldoSisa, ')
          ..write('tanggalMulai: $tanggalMulai, ')
          ..write('tanggalSelesai: $tanggalSelesai, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    namaSiklus,
    modalSetor,
    biayaAdmin,
    biayaTransaksi,
    saldoMasuk,
    saldoSisa,
    tanggalMulai,
    tanggalSelesai,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Siklus &&
          other.id == this.id &&
          other.namaSiklus == this.namaSiklus &&
          other.modalSetor == this.modalSetor &&
          other.biayaAdmin == this.biayaAdmin &&
          other.biayaTransaksi == this.biayaTransaksi &&
          other.saldoMasuk == this.saldoMasuk &&
          other.saldoSisa == this.saldoSisa &&
          other.tanggalMulai == this.tanggalMulai &&
          other.tanggalSelesai == this.tanggalSelesai &&
          other.status == this.status);
}

class SiklusTableCompanion extends UpdateCompanion<Siklus> {
  final Value<int> id;
  final Value<String> namaSiklus;
  final Value<int> modalSetor;
  final Value<int> biayaAdmin;
  final Value<int> biayaTransaksi;
  final Value<int> saldoMasuk;
  final Value<int> saldoSisa;
  final Value<DateTime> tanggalMulai;
  final Value<DateTime?> tanggalSelesai;
  final Value<String> status;
  const SiklusTableCompanion({
    this.id = const Value.absent(),
    this.namaSiklus = const Value.absent(),
    this.modalSetor = const Value.absent(),
    this.biayaAdmin = const Value.absent(),
    this.biayaTransaksi = const Value.absent(),
    this.saldoMasuk = const Value.absent(),
    this.saldoSisa = const Value.absent(),
    this.tanggalMulai = const Value.absent(),
    this.tanggalSelesai = const Value.absent(),
    this.status = const Value.absent(),
  });
  SiklusTableCompanion.insert({
    this.id = const Value.absent(),
    required String namaSiklus,
    required int modalSetor,
    this.biayaAdmin = const Value.absent(),
    this.biayaTransaksi = const Value.absent(),
    required int saldoMasuk,
    required int saldoSisa,
    this.tanggalMulai = const Value.absent(),
    this.tanggalSelesai = const Value.absent(),
    this.status = const Value.absent(),
  }) : namaSiklus = Value(namaSiklus),
       modalSetor = Value(modalSetor),
       saldoMasuk = Value(saldoMasuk),
       saldoSisa = Value(saldoSisa);
  static Insertable<Siklus> custom({
    Expression<int>? id,
    Expression<String>? namaSiklus,
    Expression<int>? modalSetor,
    Expression<int>? biayaAdmin,
    Expression<int>? biayaTransaksi,
    Expression<int>? saldoMasuk,
    Expression<int>? saldoSisa,
    Expression<DateTime>? tanggalMulai,
    Expression<DateTime>? tanggalSelesai,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (namaSiklus != null) 'nama_siklus': namaSiklus,
      if (modalSetor != null) 'modal_setor': modalSetor,
      if (biayaAdmin != null) 'biaya_admin': biayaAdmin,
      if (biayaTransaksi != null) 'biaya_transaksi': biayaTransaksi,
      if (saldoMasuk != null) 'saldo_masuk': saldoMasuk,
      if (saldoSisa != null) 'saldo_sisa': saldoSisa,
      if (tanggalMulai != null) 'tanggal_mulai': tanggalMulai,
      if (tanggalSelesai != null) 'tanggal_selesai': tanggalSelesai,
      if (status != null) 'status': status,
    });
  }

  SiklusTableCompanion copyWith({
    Value<int>? id,
    Value<String>? namaSiklus,
    Value<int>? modalSetor,
    Value<int>? biayaAdmin,
    Value<int>? biayaTransaksi,
    Value<int>? saldoMasuk,
    Value<int>? saldoSisa,
    Value<DateTime>? tanggalMulai,
    Value<DateTime?>? tanggalSelesai,
    Value<String>? status,
  }) {
    return SiklusTableCompanion(
      id: id ?? this.id,
      namaSiklus: namaSiklus ?? this.namaSiklus,
      modalSetor: modalSetor ?? this.modalSetor,
      biayaAdmin: biayaAdmin ?? this.biayaAdmin,
      biayaTransaksi: biayaTransaksi ?? this.biayaTransaksi,
      saldoMasuk: saldoMasuk ?? this.saldoMasuk,
      saldoSisa: saldoSisa ?? this.saldoSisa,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (namaSiklus.present) {
      map['nama_siklus'] = Variable<String>(namaSiklus.value);
    }
    if (modalSetor.present) {
      map['modal_setor'] = Variable<int>(modalSetor.value);
    }
    if (biayaAdmin.present) {
      map['biaya_admin'] = Variable<int>(biayaAdmin.value);
    }
    if (biayaTransaksi.present) {
      map['biaya_transaksi'] = Variable<int>(biayaTransaksi.value);
    }
    if (saldoMasuk.present) {
      map['saldo_masuk'] = Variable<int>(saldoMasuk.value);
    }
    if (saldoSisa.present) {
      map['saldo_sisa'] = Variable<int>(saldoSisa.value);
    }
    if (tanggalMulai.present) {
      map['tanggal_mulai'] = Variable<DateTime>(tanggalMulai.value);
    }
    if (tanggalSelesai.present) {
      map['tanggal_selesai'] = Variable<DateTime>(tanggalSelesai.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SiklusTableCompanion(')
          ..write('id: $id, ')
          ..write('namaSiklus: $namaSiklus, ')
          ..write('modalSetor: $modalSetor, ')
          ..write('biayaAdmin: $biayaAdmin, ')
          ..write('biayaTransaksi: $biayaTransaksi, ')
          ..write('saldoMasuk: $saldoMasuk, ')
          ..write('saldoSisa: $saldoSisa, ')
          ..write('tanggalMulai: $tanggalMulai, ')
          ..write('tanggalSelesai: $tanggalSelesai, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $ProdukTableTable extends ProdukTable
    with TableInfo<$ProdukTableTable, Produk> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProdukTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kodeDigiflazzMeta = const VerificationMeta(
    'kodeDigiflazz',
  );
  @override
  late final GeneratedColumn<String> kodeDigiflazz = GeneratedColumn<String>(
    'kode_digiflazz',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kategoriMeta = const VerificationMeta(
    'kategori',
  );
  @override
  late final GeneratedColumn<String> kategori = GeneratedColumn<String>(
    'kategori',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Lainnya'),
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _hargaBeliMeta = const VerificationMeta(
    'hargaBeli',
  );
  @override
  late final GeneratedColumn<int> hargaBeli = GeneratedColumn<int>(
    'harga_beli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaJualMeta = const VerificationMeta(
    'hargaJual',
  );
  @override
  late final GeneratedColumn<int> hargaJual = GeneratedColumn<int>(
    'harga_jual',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _aktifMeta = const VerificationMeta('aktif');
  @override
  late final GeneratedColumn<bool> aktif = GeneratedColumn<bool>(
    'aktif',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("aktif" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deskripsiMeta = const VerificationMeta(
    'deskripsi',
  );
  @override
  late final GeneratedColumn<String> deskripsi = GeneratedColumn<String>(
    'deskripsi',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kodeDigiflazz,
    nama,
    kategori,
    brand,
    hargaBeli,
    hargaJual,
    aktif,
    deskripsi,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'produk';
  @override
  VerificationContext validateIntegrity(
    Insertable<Produk> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kode_digiflazz')) {
      context.handle(
        _kodeDigiflazzMeta,
        kodeDigiflazz.isAcceptableOrUnknown(
          data['kode_digiflazz']!,
          _kodeDigiflazzMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kodeDigiflazzMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('kategori')) {
      context.handle(
        _kategoriMeta,
        kategori.isAcceptableOrUnknown(data['kategori']!, _kategoriMeta),
      );
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('harga_beli')) {
      context.handle(
        _hargaBeliMeta,
        hargaBeli.isAcceptableOrUnknown(data['harga_beli']!, _hargaBeliMeta),
      );
    } else if (isInserting) {
      context.missing(_hargaBeliMeta);
    }
    if (data.containsKey('harga_jual')) {
      context.handle(
        _hargaJualMeta,
        hargaJual.isAcceptableOrUnknown(data['harga_jual']!, _hargaJualMeta),
      );
    }
    if (data.containsKey('aktif')) {
      context.handle(
        _aktifMeta,
        aktif.isAcceptableOrUnknown(data['aktif']!, _aktifMeta),
      );
    }
    if (data.containsKey('deskripsi')) {
      context.handle(
        _deskripsiMeta,
        deskripsi.isAcceptableOrUnknown(data['deskripsi']!, _deskripsiMeta),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {kodeDigiflazz},
  ];
  @override
  Produk map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Produk(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kodeDigiflazz: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kode_digiflazz'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      kategori: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategori'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      hargaBeli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}harga_beli'],
      )!,
      hargaJual: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}harga_jual'],
      )!,
      aktif: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}aktif'],
      )!,
      deskripsi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deskripsi'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $ProdukTableTable createAlias(String alias) {
    return $ProdukTableTable(attachedDatabase, alias);
  }
}

class Produk extends DataClass implements Insertable<Produk> {
  /// ID auto-increment (internal)
  final int id;

  /// Kode produk dari Digiflazz (buyer_sku_code), misal "xld10"
  final String kodeDigiflazz;

  /// Nama produk, misal "Telkomsel 10k"
  final String nama;

  /// Kategori: Pulsa, Token Listrik, Paket Data, dll.
  final String kategori;

  /// Brand/operator, misal "Telkomsel", "PLN", "XL"
  final String brand;

  /// Harga beli dari supplier Digiflazz (dalam Rupiah)
  final int hargaBeli;

  /// Harga jual ke pelanggan (diisi manual oleh user, dalam Rupiah)
  final int hargaJual;

  /// Apakah produk ini aktif dijual oleh user
  final bool aktif;

  /// Deskripsi tambahan dari Digiflazz (opsional)
  final String deskripsi;

  /// Terakhir diperbarui dari API Digiflazz
  final DateTime lastUpdated;
  const Produk({
    required this.id,
    required this.kodeDigiflazz,
    required this.nama,
    required this.kategori,
    required this.brand,
    required this.hargaBeli,
    required this.hargaJual,
    required this.aktif,
    required this.deskripsi,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kode_digiflazz'] = Variable<String>(kodeDigiflazz);
    map['nama'] = Variable<String>(nama);
    map['kategori'] = Variable<String>(kategori);
    map['brand'] = Variable<String>(brand);
    map['harga_beli'] = Variable<int>(hargaBeli);
    map['harga_jual'] = Variable<int>(hargaJual);
    map['aktif'] = Variable<bool>(aktif);
    map['deskripsi'] = Variable<String>(deskripsi);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  ProdukTableCompanion toCompanion(bool nullToAbsent) {
    return ProdukTableCompanion(
      id: Value(id),
      kodeDigiflazz: Value(kodeDigiflazz),
      nama: Value(nama),
      kategori: Value(kategori),
      brand: Value(brand),
      hargaBeli: Value(hargaBeli),
      hargaJual: Value(hargaJual),
      aktif: Value(aktif),
      deskripsi: Value(deskripsi),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory Produk.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Produk(
      id: serializer.fromJson<int>(json['id']),
      kodeDigiflazz: serializer.fromJson<String>(json['kodeDigiflazz']),
      nama: serializer.fromJson<String>(json['nama']),
      kategori: serializer.fromJson<String>(json['kategori']),
      brand: serializer.fromJson<String>(json['brand']),
      hargaBeli: serializer.fromJson<int>(json['hargaBeli']),
      hargaJual: serializer.fromJson<int>(json['hargaJual']),
      aktif: serializer.fromJson<bool>(json['aktif']),
      deskripsi: serializer.fromJson<String>(json['deskripsi']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kodeDigiflazz': serializer.toJson<String>(kodeDigiflazz),
      'nama': serializer.toJson<String>(nama),
      'kategori': serializer.toJson<String>(kategori),
      'brand': serializer.toJson<String>(brand),
      'hargaBeli': serializer.toJson<int>(hargaBeli),
      'hargaJual': serializer.toJson<int>(hargaJual),
      'aktif': serializer.toJson<bool>(aktif),
      'deskripsi': serializer.toJson<String>(deskripsi),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  Produk copyWith({
    int? id,
    String? kodeDigiflazz,
    String? nama,
    String? kategori,
    String? brand,
    int? hargaBeli,
    int? hargaJual,
    bool? aktif,
    String? deskripsi,
    DateTime? lastUpdated,
  }) => Produk(
    id: id ?? this.id,
    kodeDigiflazz: kodeDigiflazz ?? this.kodeDigiflazz,
    nama: nama ?? this.nama,
    kategori: kategori ?? this.kategori,
    brand: brand ?? this.brand,
    hargaBeli: hargaBeli ?? this.hargaBeli,
    hargaJual: hargaJual ?? this.hargaJual,
    aktif: aktif ?? this.aktif,
    deskripsi: deskripsi ?? this.deskripsi,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  Produk copyWithCompanion(ProdukTableCompanion data) {
    return Produk(
      id: data.id.present ? data.id.value : this.id,
      kodeDigiflazz: data.kodeDigiflazz.present
          ? data.kodeDigiflazz.value
          : this.kodeDigiflazz,
      nama: data.nama.present ? data.nama.value : this.nama,
      kategori: data.kategori.present ? data.kategori.value : this.kategori,
      brand: data.brand.present ? data.brand.value : this.brand,
      hargaBeli: data.hargaBeli.present ? data.hargaBeli.value : this.hargaBeli,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      aktif: data.aktif.present ? data.aktif.value : this.aktif,
      deskripsi: data.deskripsi.present ? data.deskripsi.value : this.deskripsi,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Produk(')
          ..write('id: $id, ')
          ..write('kodeDigiflazz: $kodeDigiflazz, ')
          ..write('nama: $nama, ')
          ..write('kategori: $kategori, ')
          ..write('brand: $brand, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('aktif: $aktif, ')
          ..write('deskripsi: $deskripsi, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kodeDigiflazz,
    nama,
    kategori,
    brand,
    hargaBeli,
    hargaJual,
    aktif,
    deskripsi,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Produk &&
          other.id == this.id &&
          other.kodeDigiflazz == this.kodeDigiflazz &&
          other.nama == this.nama &&
          other.kategori == this.kategori &&
          other.brand == this.brand &&
          other.hargaBeli == this.hargaBeli &&
          other.hargaJual == this.hargaJual &&
          other.aktif == this.aktif &&
          other.deskripsi == this.deskripsi &&
          other.lastUpdated == this.lastUpdated);
}

class ProdukTableCompanion extends UpdateCompanion<Produk> {
  final Value<int> id;
  final Value<String> kodeDigiflazz;
  final Value<String> nama;
  final Value<String> kategori;
  final Value<String> brand;
  final Value<int> hargaBeli;
  final Value<int> hargaJual;
  final Value<bool> aktif;
  final Value<String> deskripsi;
  final Value<DateTime> lastUpdated;
  const ProdukTableCompanion({
    this.id = const Value.absent(),
    this.kodeDigiflazz = const Value.absent(),
    this.nama = const Value.absent(),
    this.kategori = const Value.absent(),
    this.brand = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.aktif = const Value.absent(),
    this.deskripsi = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  ProdukTableCompanion.insert({
    this.id = const Value.absent(),
    required String kodeDigiflazz,
    required String nama,
    this.kategori = const Value.absent(),
    this.brand = const Value.absent(),
    required int hargaBeli,
    this.hargaJual = const Value.absent(),
    this.aktif = const Value.absent(),
    this.deskripsi = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  }) : kodeDigiflazz = Value(kodeDigiflazz),
       nama = Value(nama),
       hargaBeli = Value(hargaBeli);
  static Insertable<Produk> custom({
    Expression<int>? id,
    Expression<String>? kodeDigiflazz,
    Expression<String>? nama,
    Expression<String>? kategori,
    Expression<String>? brand,
    Expression<int>? hargaBeli,
    Expression<int>? hargaJual,
    Expression<bool>? aktif,
    Expression<String>? deskripsi,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kodeDigiflazz != null) 'kode_digiflazz': kodeDigiflazz,
      if (nama != null) 'nama': nama,
      if (kategori != null) 'kategori': kategori,
      if (brand != null) 'brand': brand,
      if (hargaBeli != null) 'harga_beli': hargaBeli,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (aktif != null) 'aktif': aktif,
      if (deskripsi != null) 'deskripsi': deskripsi,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  ProdukTableCompanion copyWith({
    Value<int>? id,
    Value<String>? kodeDigiflazz,
    Value<String>? nama,
    Value<String>? kategori,
    Value<String>? brand,
    Value<int>? hargaBeli,
    Value<int>? hargaJual,
    Value<bool>? aktif,
    Value<String>? deskripsi,
    Value<DateTime>? lastUpdated,
  }) {
    return ProdukTableCompanion(
      id: id ?? this.id,
      kodeDigiflazz: kodeDigiflazz ?? this.kodeDigiflazz,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      brand: brand ?? this.brand,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      aktif: aktif ?? this.aktif,
      deskripsi: deskripsi ?? this.deskripsi,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kodeDigiflazz.present) {
      map['kode_digiflazz'] = Variable<String>(kodeDigiflazz.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (kategori.present) {
      map['kategori'] = Variable<String>(kategori.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (hargaBeli.present) {
      map['harga_beli'] = Variable<int>(hargaBeli.value);
    }
    if (hargaJual.present) {
      map['harga_jual'] = Variable<int>(hargaJual.value);
    }
    if (aktif.present) {
      map['aktif'] = Variable<bool>(aktif.value);
    }
    if (deskripsi.present) {
      map['deskripsi'] = Variable<String>(deskripsi.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProdukTableCompanion(')
          ..write('id: $id, ')
          ..write('kodeDigiflazz: $kodeDigiflazz, ')
          ..write('nama: $nama, ')
          ..write('kategori: $kategori, ')
          ..write('brand: $brand, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('aktif: $aktif, ')
          ..write('deskripsi: $deskripsi, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $PelangganTableTable extends PelangganTable
    with TableInfo<$PelangganTableTable, Pelanggan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PelangganTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noHpMeta = const VerificationMeta('noHp');
  @override
  late final GeneratedColumn<String> noHp = GeneratedColumn<String>(
    'no_hp',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nama, noHp, catatan, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pelanggan';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pelanggan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('no_hp')) {
      context.handle(
        _noHpMeta,
        noHp.isAcceptableOrUnknown(data['no_hp']!, _noHpMeta),
      );
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pelanggan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pelanggan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      noHp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}no_hp'],
      )!,
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PelangganTableTable createAlias(String alias) {
    return $PelangganTableTable(attachedDatabase, alias);
  }
}

class Pelanggan extends DataClass implements Insertable<Pelanggan> {
  /// ID auto-increment
  final int id;

  /// Nama pelanggan
  final String nama;

  /// Nomor HP pelanggan (opsional)
  final String noHp;

  /// Catatan tambahan (opsional)
  final String catatan;

  /// Tanggal pelanggan ditambahkan
  final DateTime createdAt;
  const Pelanggan({
    required this.id,
    required this.nama,
    required this.noHp,
    required this.catatan,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nama'] = Variable<String>(nama);
    map['no_hp'] = Variable<String>(noHp);
    map['catatan'] = Variable<String>(catatan);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PelangganTableCompanion toCompanion(bool nullToAbsent) {
    return PelangganTableCompanion(
      id: Value(id),
      nama: Value(nama),
      noHp: Value(noHp),
      catatan: Value(catatan),
      createdAt: Value(createdAt),
    );
  }

  factory Pelanggan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pelanggan(
      id: serializer.fromJson<int>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      noHp: serializer.fromJson<String>(json['noHp']),
      catatan: serializer.fromJson<String>(json['catatan']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nama': serializer.toJson<String>(nama),
      'noHp': serializer.toJson<String>(noHp),
      'catatan': serializer.toJson<String>(catatan),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Pelanggan copyWith({
    int? id,
    String? nama,
    String? noHp,
    String? catatan,
    DateTime? createdAt,
  }) => Pelanggan(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    noHp: noHp ?? this.noHp,
    catatan: catatan ?? this.catatan,
    createdAt: createdAt ?? this.createdAt,
  );
  Pelanggan copyWithCompanion(PelangganTableCompanion data) {
    return Pelanggan(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      noHp: data.noHp.present ? data.noHp.value : this.noHp,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pelanggan(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('noHp: $noHp, ')
          ..write('catatan: $catatan, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nama, noHp, catatan, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pelanggan &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.noHp == this.noHp &&
          other.catatan == this.catatan &&
          other.createdAt == this.createdAt);
}

class PelangganTableCompanion extends UpdateCompanion<Pelanggan> {
  final Value<int> id;
  final Value<String> nama;
  final Value<String> noHp;
  final Value<String> catatan;
  final Value<DateTime> createdAt;
  const PelangganTableCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.noHp = const Value.absent(),
    this.catatan = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PelangganTableCompanion.insert({
    this.id = const Value.absent(),
    required String nama,
    this.noHp = const Value.absent(),
    this.catatan = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : nama = Value(nama);
  static Insertable<Pelanggan> custom({
    Expression<int>? id,
    Expression<String>? nama,
    Expression<String>? noHp,
    Expression<String>? catatan,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (noHp != null) 'no_hp': noHp,
      if (catatan != null) 'catatan': catatan,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PelangganTableCompanion copyWith({
    Value<int>? id,
    Value<String>? nama,
    Value<String>? noHp,
    Value<String>? catatan,
    Value<DateTime>? createdAt,
  }) {
    return PelangganTableCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      noHp: noHp ?? this.noHp,
      catatan: catatan ?? this.catatan,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (noHp.present) {
      map['no_hp'] = Variable<String>(noHp.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PelangganTableCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('noHp: $noHp, ')
          ..write('catatan: $catatan, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TransaksiTableTable extends TransaksiTable
    with TableInfo<$TransaksiTableTable, Transaksi> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransaksiTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idPelangganMeta = const VerificationMeta(
    'idPelanggan',
  );
  @override
  late final GeneratedColumn<int> idPelanggan = GeneratedColumn<int>(
    'id_pelanggan',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES pelanggan (id)',
    ),
  );
  static const VerificationMeta _idProdukMeta = const VerificationMeta(
    'idProduk',
  );
  @override
  late final GeneratedColumn<int> idProduk = GeneratedColumn<int>(
    'id_produk',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES produk (id)',
    ),
  );
  static const VerificationMeta _namaProdukMeta = const VerificationMeta(
    'namaProduk',
  );
  @override
  late final GeneratedColumn<String> namaProduk = GeneratedColumn<String>(
    'nama_produk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _hargaBeliMeta = const VerificationMeta(
    'hargaBeli',
  );
  @override
  late final GeneratedColumn<int> hargaBeli = GeneratedColumn<int>(
    'harga_beli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaJualMeta = const VerificationMeta(
    'hargaJual',
  );
  @override
  late final GeneratedColumn<int> hargaJual = GeneratedColumn<int>(
    'harga_jual',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profitMeta = const VerificationMeta('profit');
  @override
  late final GeneratedColumn<int> profit = GeneratedColumn<int>(
    'profit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusBayarMeta = const VerificationMeta(
    'statusBayar',
  );
  @override
  late final GeneratedColumn<String> statusBayar = GeneratedColumn<String>(
    'status_bayar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('lunas'),
  );
  static const VerificationMeta _statusKirimMeta = const VerificationMeta(
    'statusKirim',
  );
  @override
  late final GeneratedColumn<String> statusKirim = GeneratedColumn<String>(
    'status_kirim',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _tujuanMeta = const VerificationMeta('tujuan');
  @override
  late final GeneratedColumn<String> tujuan = GeneratedColumn<String>(
    'tujuan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idPelanggan,
    idProduk,
    namaProduk,
    hargaBeli,
    hargaJual,
    profit,
    statusBayar,
    statusKirim,
    tujuan,
    catatan,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaksi';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaksi> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_pelanggan')) {
      context.handle(
        _idPelangganMeta,
        idPelanggan.isAcceptableOrUnknown(
          data['id_pelanggan']!,
          _idPelangganMeta,
        ),
      );
    }
    if (data.containsKey('id_produk')) {
      context.handle(
        _idProdukMeta,
        idProduk.isAcceptableOrUnknown(data['id_produk']!, _idProdukMeta),
      );
    }
    if (data.containsKey('nama_produk')) {
      context.handle(
        _namaProdukMeta,
        namaProduk.isAcceptableOrUnknown(data['nama_produk']!, _namaProdukMeta),
      );
    }
    if (data.containsKey('harga_beli')) {
      context.handle(
        _hargaBeliMeta,
        hargaBeli.isAcceptableOrUnknown(data['harga_beli']!, _hargaBeliMeta),
      );
    } else if (isInserting) {
      context.missing(_hargaBeliMeta);
    }
    if (data.containsKey('harga_jual')) {
      context.handle(
        _hargaJualMeta,
        hargaJual.isAcceptableOrUnknown(data['harga_jual']!, _hargaJualMeta),
      );
    } else if (isInserting) {
      context.missing(_hargaJualMeta);
    }
    if (data.containsKey('profit')) {
      context.handle(
        _profitMeta,
        profit.isAcceptableOrUnknown(data['profit']!, _profitMeta),
      );
    } else if (isInserting) {
      context.missing(_profitMeta);
    }
    if (data.containsKey('status_bayar')) {
      context.handle(
        _statusBayarMeta,
        statusBayar.isAcceptableOrUnknown(
          data['status_bayar']!,
          _statusBayarMeta,
        ),
      );
    }
    if (data.containsKey('status_kirim')) {
      context.handle(
        _statusKirimMeta,
        statusKirim.isAcceptableOrUnknown(
          data['status_kirim']!,
          _statusKirimMeta,
        ),
      );
    }
    if (data.containsKey('tujuan')) {
      context.handle(
        _tujuanMeta,
        tujuan.isAcceptableOrUnknown(data['tujuan']!, _tujuanMeta),
      );
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaksi map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaksi(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idPelanggan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_pelanggan'],
      ),
      idProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_produk'],
      ),
      namaProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_produk'],
      )!,
      hargaBeli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}harga_beli'],
      )!,
      hargaJual: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}harga_jual'],
      )!,
      profit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profit'],
      )!,
      statusBayar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_bayar'],
      )!,
      statusKirim: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_kirim'],
      )!,
      tujuan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tujuan'],
      )!,
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransaksiTableTable createAlias(String alias) {
    return $TransaksiTableTable(attachedDatabase, alias);
  }
}

class Transaksi extends DataClass implements Insertable<Transaksi> {
  /// ID auto-increment
  final int id;

  /// FK ke pelanggan (nullable — pelanggan bisa "Umum")
  final int? idPelanggan;

  /// FK ke produk (nullable — referensi bisa hilang)
  final int? idProduk;

  /// Nama produk (disimpan snapshot agar tetap ada walau produk dihapus)
  final String namaProduk;

  /// Harga beli saat transaksi terjadi (snapshot, dalam Rupiah)
  final int hargaBeli;

  /// Harga jual ke pelanggan (snapshot, dalam Rupiah)
  final int hargaJual;

  /// Profit = harga_jual - harga_beli
  final int profit;

  /// Status bayar: 'lunas' atau 'utang'
  final String statusBayar;

  /// Status kirim ke Digiflazz: 'pending', 'sukses', 'gagal', 'manual'
  final String statusKirim;

  /// Nomor tujuan pengisian (no HP pelanggan)
  final String tujuan;

  /// Catatan tambahan (opsional)
  final String catatan;

  /// Waktu transaksi dibuat
  final DateTime createdAt;
  const Transaksi({
    required this.id,
    this.idPelanggan,
    this.idProduk,
    required this.namaProduk,
    required this.hargaBeli,
    required this.hargaJual,
    required this.profit,
    required this.statusBayar,
    required this.statusKirim,
    required this.tujuan,
    required this.catatan,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || idPelanggan != null) {
      map['id_pelanggan'] = Variable<int>(idPelanggan);
    }
    if (!nullToAbsent || idProduk != null) {
      map['id_produk'] = Variable<int>(idProduk);
    }
    map['nama_produk'] = Variable<String>(namaProduk);
    map['harga_beli'] = Variable<int>(hargaBeli);
    map['harga_jual'] = Variable<int>(hargaJual);
    map['profit'] = Variable<int>(profit);
    map['status_bayar'] = Variable<String>(statusBayar);
    map['status_kirim'] = Variable<String>(statusKirim);
    map['tujuan'] = Variable<String>(tujuan);
    map['catatan'] = Variable<String>(catatan);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransaksiTableCompanion toCompanion(bool nullToAbsent) {
    return TransaksiTableCompanion(
      id: Value(id),
      idPelanggan: idPelanggan == null && nullToAbsent
          ? const Value.absent()
          : Value(idPelanggan),
      idProduk: idProduk == null && nullToAbsent
          ? const Value.absent()
          : Value(idProduk),
      namaProduk: Value(namaProduk),
      hargaBeli: Value(hargaBeli),
      hargaJual: Value(hargaJual),
      profit: Value(profit),
      statusBayar: Value(statusBayar),
      statusKirim: Value(statusKirim),
      tujuan: Value(tujuan),
      catatan: Value(catatan),
      createdAt: Value(createdAt),
    );
  }

  factory Transaksi.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaksi(
      id: serializer.fromJson<int>(json['id']),
      idPelanggan: serializer.fromJson<int?>(json['idPelanggan']),
      idProduk: serializer.fromJson<int?>(json['idProduk']),
      namaProduk: serializer.fromJson<String>(json['namaProduk']),
      hargaBeli: serializer.fromJson<int>(json['hargaBeli']),
      hargaJual: serializer.fromJson<int>(json['hargaJual']),
      profit: serializer.fromJson<int>(json['profit']),
      statusBayar: serializer.fromJson<String>(json['statusBayar']),
      statusKirim: serializer.fromJson<String>(json['statusKirim']),
      tujuan: serializer.fromJson<String>(json['tujuan']),
      catatan: serializer.fromJson<String>(json['catatan']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idPelanggan': serializer.toJson<int?>(idPelanggan),
      'idProduk': serializer.toJson<int?>(idProduk),
      'namaProduk': serializer.toJson<String>(namaProduk),
      'hargaBeli': serializer.toJson<int>(hargaBeli),
      'hargaJual': serializer.toJson<int>(hargaJual),
      'profit': serializer.toJson<int>(profit),
      'statusBayar': serializer.toJson<String>(statusBayar),
      'statusKirim': serializer.toJson<String>(statusKirim),
      'tujuan': serializer.toJson<String>(tujuan),
      'catatan': serializer.toJson<String>(catatan),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Transaksi copyWith({
    int? id,
    Value<int?> idPelanggan = const Value.absent(),
    Value<int?> idProduk = const Value.absent(),
    String? namaProduk,
    int? hargaBeli,
    int? hargaJual,
    int? profit,
    String? statusBayar,
    String? statusKirim,
    String? tujuan,
    String? catatan,
    DateTime? createdAt,
  }) => Transaksi(
    id: id ?? this.id,
    idPelanggan: idPelanggan.present ? idPelanggan.value : this.idPelanggan,
    idProduk: idProduk.present ? idProduk.value : this.idProduk,
    namaProduk: namaProduk ?? this.namaProduk,
    hargaBeli: hargaBeli ?? this.hargaBeli,
    hargaJual: hargaJual ?? this.hargaJual,
    profit: profit ?? this.profit,
    statusBayar: statusBayar ?? this.statusBayar,
    statusKirim: statusKirim ?? this.statusKirim,
    tujuan: tujuan ?? this.tujuan,
    catatan: catatan ?? this.catatan,
    createdAt: createdAt ?? this.createdAt,
  );
  Transaksi copyWithCompanion(TransaksiTableCompanion data) {
    return Transaksi(
      id: data.id.present ? data.id.value : this.id,
      idPelanggan: data.idPelanggan.present
          ? data.idPelanggan.value
          : this.idPelanggan,
      idProduk: data.idProduk.present ? data.idProduk.value : this.idProduk,
      namaProduk: data.namaProduk.present
          ? data.namaProduk.value
          : this.namaProduk,
      hargaBeli: data.hargaBeli.present ? data.hargaBeli.value : this.hargaBeli,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      profit: data.profit.present ? data.profit.value : this.profit,
      statusBayar: data.statusBayar.present
          ? data.statusBayar.value
          : this.statusBayar,
      statusKirim: data.statusKirim.present
          ? data.statusKirim.value
          : this.statusKirim,
      tujuan: data.tujuan.present ? data.tujuan.value : this.tujuan,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaksi(')
          ..write('id: $id, ')
          ..write('idPelanggan: $idPelanggan, ')
          ..write('idProduk: $idProduk, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('profit: $profit, ')
          ..write('statusBayar: $statusBayar, ')
          ..write('statusKirim: $statusKirim, ')
          ..write('tujuan: $tujuan, ')
          ..write('catatan: $catatan, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idPelanggan,
    idProduk,
    namaProduk,
    hargaBeli,
    hargaJual,
    profit,
    statusBayar,
    statusKirim,
    tujuan,
    catatan,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaksi &&
          other.id == this.id &&
          other.idPelanggan == this.idPelanggan &&
          other.idProduk == this.idProduk &&
          other.namaProduk == this.namaProduk &&
          other.hargaBeli == this.hargaBeli &&
          other.hargaJual == this.hargaJual &&
          other.profit == this.profit &&
          other.statusBayar == this.statusBayar &&
          other.statusKirim == this.statusKirim &&
          other.tujuan == this.tujuan &&
          other.catatan == this.catatan &&
          other.createdAt == this.createdAt);
}

class TransaksiTableCompanion extends UpdateCompanion<Transaksi> {
  final Value<int> id;
  final Value<int?> idPelanggan;
  final Value<int?> idProduk;
  final Value<String> namaProduk;
  final Value<int> hargaBeli;
  final Value<int> hargaJual;
  final Value<int> profit;
  final Value<String> statusBayar;
  final Value<String> statusKirim;
  final Value<String> tujuan;
  final Value<String> catatan;
  final Value<DateTime> createdAt;
  const TransaksiTableCompanion({
    this.id = const Value.absent(),
    this.idPelanggan = const Value.absent(),
    this.idProduk = const Value.absent(),
    this.namaProduk = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.profit = const Value.absent(),
    this.statusBayar = const Value.absent(),
    this.statusKirim = const Value.absent(),
    this.tujuan = const Value.absent(),
    this.catatan = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransaksiTableCompanion.insert({
    this.id = const Value.absent(),
    this.idPelanggan = const Value.absent(),
    this.idProduk = const Value.absent(),
    this.namaProduk = const Value.absent(),
    required int hargaBeli,
    required int hargaJual,
    required int profit,
    this.statusBayar = const Value.absent(),
    this.statusKirim = const Value.absent(),
    this.tujuan = const Value.absent(),
    this.catatan = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : hargaBeli = Value(hargaBeli),
       hargaJual = Value(hargaJual),
       profit = Value(profit);
  static Insertable<Transaksi> custom({
    Expression<int>? id,
    Expression<int>? idPelanggan,
    Expression<int>? idProduk,
    Expression<String>? namaProduk,
    Expression<int>? hargaBeli,
    Expression<int>? hargaJual,
    Expression<int>? profit,
    Expression<String>? statusBayar,
    Expression<String>? statusKirim,
    Expression<String>? tujuan,
    Expression<String>? catatan,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idPelanggan != null) 'id_pelanggan': idPelanggan,
      if (idProduk != null) 'id_produk': idProduk,
      if (namaProduk != null) 'nama_produk': namaProduk,
      if (hargaBeli != null) 'harga_beli': hargaBeli,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (profit != null) 'profit': profit,
      if (statusBayar != null) 'status_bayar': statusBayar,
      if (statusKirim != null) 'status_kirim': statusKirim,
      if (tujuan != null) 'tujuan': tujuan,
      if (catatan != null) 'catatan': catatan,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransaksiTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? idPelanggan,
    Value<int?>? idProduk,
    Value<String>? namaProduk,
    Value<int>? hargaBeli,
    Value<int>? hargaJual,
    Value<int>? profit,
    Value<String>? statusBayar,
    Value<String>? statusKirim,
    Value<String>? tujuan,
    Value<String>? catatan,
    Value<DateTime>? createdAt,
  }) {
    return TransaksiTableCompanion(
      id: id ?? this.id,
      idPelanggan: idPelanggan ?? this.idPelanggan,
      idProduk: idProduk ?? this.idProduk,
      namaProduk: namaProduk ?? this.namaProduk,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      profit: profit ?? this.profit,
      statusBayar: statusBayar ?? this.statusBayar,
      statusKirim: statusKirim ?? this.statusKirim,
      tujuan: tujuan ?? this.tujuan,
      catatan: catatan ?? this.catatan,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idPelanggan.present) {
      map['id_pelanggan'] = Variable<int>(idPelanggan.value);
    }
    if (idProduk.present) {
      map['id_produk'] = Variable<int>(idProduk.value);
    }
    if (namaProduk.present) {
      map['nama_produk'] = Variable<String>(namaProduk.value);
    }
    if (hargaBeli.present) {
      map['harga_beli'] = Variable<int>(hargaBeli.value);
    }
    if (hargaJual.present) {
      map['harga_jual'] = Variable<int>(hargaJual.value);
    }
    if (profit.present) {
      map['profit'] = Variable<int>(profit.value);
    }
    if (statusBayar.present) {
      map['status_bayar'] = Variable<String>(statusBayar.value);
    }
    if (statusKirim.present) {
      map['status_kirim'] = Variable<String>(statusKirim.value);
    }
    if (tujuan.present) {
      map['tujuan'] = Variable<String>(tujuan.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransaksiTableCompanion(')
          ..write('id: $id, ')
          ..write('idPelanggan: $idPelanggan, ')
          ..write('idProduk: $idProduk, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('profit: $profit, ')
          ..write('statusBayar: $statusBayar, ')
          ..write('statusKirim: $statusKirim, ')
          ..write('tujuan: $tujuan, ')
          ..write('catatan: $catatan, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DetailKonsumsiSiklusTableTable extends DetailKonsumsiSiklusTable
    with TableInfo<$DetailKonsumsiSiklusTableTable, DetailKonsumsiSiklus> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DetailKonsumsiSiklusTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idTransaksiMeta = const VerificationMeta(
    'idTransaksi',
  );
  @override
  late final GeneratedColumn<int> idTransaksi = GeneratedColumn<int>(
    'id_transaksi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transaksi (id)',
    ),
  );
  static const VerificationMeta _idSiklusMeta = const VerificationMeta(
    'idSiklus',
  );
  @override
  late final GeneratedColumn<int> idSiklus = GeneratedColumn<int>(
    'id_siklus',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES siklus (id)',
    ),
  );
  static const VerificationMeta _jumlahDikonsumsiMeta = const VerificationMeta(
    'jumlahDikonsumsi',
  );
  @override
  late final GeneratedColumn<int> jumlahDikonsumsi = GeneratedColumn<int>(
    'jumlah_dikonsumsi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idTransaksi,
    idSiklus,
    jumlahDikonsumsi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'detail_konsumsi_siklus';
  @override
  VerificationContext validateIntegrity(
    Insertable<DetailKonsumsiSiklus> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_transaksi')) {
      context.handle(
        _idTransaksiMeta,
        idTransaksi.isAcceptableOrUnknown(
          data['id_transaksi']!,
          _idTransaksiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idTransaksiMeta);
    }
    if (data.containsKey('id_siklus')) {
      context.handle(
        _idSiklusMeta,
        idSiklus.isAcceptableOrUnknown(data['id_siklus']!, _idSiklusMeta),
      );
    } else if (isInserting) {
      context.missing(_idSiklusMeta);
    }
    if (data.containsKey('jumlah_dikonsumsi')) {
      context.handle(
        _jumlahDikonsumsiMeta,
        jumlahDikonsumsi.isAcceptableOrUnknown(
          data['jumlah_dikonsumsi']!,
          _jumlahDikonsumsiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jumlahDikonsumsiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DetailKonsumsiSiklus map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DetailKonsumsiSiklus(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idTransaksi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_transaksi'],
      )!,
      idSiklus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_siklus'],
      )!,
      jumlahDikonsumsi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jumlah_dikonsumsi'],
      )!,
    );
  }

  @override
  $DetailKonsumsiSiklusTableTable createAlias(String alias) {
    return $DetailKonsumsiSiklusTableTable(attachedDatabase, alias);
  }
}

class DetailKonsumsiSiklus extends DataClass
    implements Insertable<DetailKonsumsiSiklus> {
  /// ID auto-increment
  final int id;

  /// FK ke transaksi yang mengkonsumsi saldo
  final int idTransaksi;

  /// FK ke siklus yang saldonya dikonsumsi
  final int idSiklus;

  /// Jumlah saldo yang dikonsumsi dari siklus ini (dalam Rupiah)
  final int jumlahDikonsumsi;
  const DetailKonsumsiSiklus({
    required this.id,
    required this.idTransaksi,
    required this.idSiklus,
    required this.jumlahDikonsumsi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_transaksi'] = Variable<int>(idTransaksi);
    map['id_siklus'] = Variable<int>(idSiklus);
    map['jumlah_dikonsumsi'] = Variable<int>(jumlahDikonsumsi);
    return map;
  }

  DetailKonsumsiSiklusTableCompanion toCompanion(bool nullToAbsent) {
    return DetailKonsumsiSiklusTableCompanion(
      id: Value(id),
      idTransaksi: Value(idTransaksi),
      idSiklus: Value(idSiklus),
      jumlahDikonsumsi: Value(jumlahDikonsumsi),
    );
  }

  factory DetailKonsumsiSiklus.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DetailKonsumsiSiklus(
      id: serializer.fromJson<int>(json['id']),
      idTransaksi: serializer.fromJson<int>(json['idTransaksi']),
      idSiklus: serializer.fromJson<int>(json['idSiklus']),
      jumlahDikonsumsi: serializer.fromJson<int>(json['jumlahDikonsumsi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idTransaksi': serializer.toJson<int>(idTransaksi),
      'idSiklus': serializer.toJson<int>(idSiklus),
      'jumlahDikonsumsi': serializer.toJson<int>(jumlahDikonsumsi),
    };
  }

  DetailKonsumsiSiklus copyWith({
    int? id,
    int? idTransaksi,
    int? idSiklus,
    int? jumlahDikonsumsi,
  }) => DetailKonsumsiSiklus(
    id: id ?? this.id,
    idTransaksi: idTransaksi ?? this.idTransaksi,
    idSiklus: idSiklus ?? this.idSiklus,
    jumlahDikonsumsi: jumlahDikonsumsi ?? this.jumlahDikonsumsi,
  );
  DetailKonsumsiSiklus copyWithCompanion(
    DetailKonsumsiSiklusTableCompanion data,
  ) {
    return DetailKonsumsiSiklus(
      id: data.id.present ? data.id.value : this.id,
      idTransaksi: data.idTransaksi.present
          ? data.idTransaksi.value
          : this.idTransaksi,
      idSiklus: data.idSiklus.present ? data.idSiklus.value : this.idSiklus,
      jumlahDikonsumsi: data.jumlahDikonsumsi.present
          ? data.jumlahDikonsumsi.value
          : this.jumlahDikonsumsi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DetailKonsumsiSiklus(')
          ..write('id: $id, ')
          ..write('idTransaksi: $idTransaksi, ')
          ..write('idSiklus: $idSiklus, ')
          ..write('jumlahDikonsumsi: $jumlahDikonsumsi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idTransaksi, idSiklus, jumlahDikonsumsi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DetailKonsumsiSiklus &&
          other.id == this.id &&
          other.idTransaksi == this.idTransaksi &&
          other.idSiklus == this.idSiklus &&
          other.jumlahDikonsumsi == this.jumlahDikonsumsi);
}

class DetailKonsumsiSiklusTableCompanion
    extends UpdateCompanion<DetailKonsumsiSiklus> {
  final Value<int> id;
  final Value<int> idTransaksi;
  final Value<int> idSiklus;
  final Value<int> jumlahDikonsumsi;
  const DetailKonsumsiSiklusTableCompanion({
    this.id = const Value.absent(),
    this.idTransaksi = const Value.absent(),
    this.idSiklus = const Value.absent(),
    this.jumlahDikonsumsi = const Value.absent(),
  });
  DetailKonsumsiSiklusTableCompanion.insert({
    this.id = const Value.absent(),
    required int idTransaksi,
    required int idSiklus,
    required int jumlahDikonsumsi,
  }) : idTransaksi = Value(idTransaksi),
       idSiklus = Value(idSiklus),
       jumlahDikonsumsi = Value(jumlahDikonsumsi);
  static Insertable<DetailKonsumsiSiklus> custom({
    Expression<int>? id,
    Expression<int>? idTransaksi,
    Expression<int>? idSiklus,
    Expression<int>? jumlahDikonsumsi,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idTransaksi != null) 'id_transaksi': idTransaksi,
      if (idSiklus != null) 'id_siklus': idSiklus,
      if (jumlahDikonsumsi != null) 'jumlah_dikonsumsi': jumlahDikonsumsi,
    });
  }

  DetailKonsumsiSiklusTableCompanion copyWith({
    Value<int>? id,
    Value<int>? idTransaksi,
    Value<int>? idSiklus,
    Value<int>? jumlahDikonsumsi,
  }) {
    return DetailKonsumsiSiklusTableCompanion(
      id: id ?? this.id,
      idTransaksi: idTransaksi ?? this.idTransaksi,
      idSiklus: idSiklus ?? this.idSiklus,
      jumlahDikonsumsi: jumlahDikonsumsi ?? this.jumlahDikonsumsi,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idTransaksi.present) {
      map['id_transaksi'] = Variable<int>(idTransaksi.value);
    }
    if (idSiklus.present) {
      map['id_siklus'] = Variable<int>(idSiklus.value);
    }
    if (jumlahDikonsumsi.present) {
      map['jumlah_dikonsumsi'] = Variable<int>(jumlahDikonsumsi.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DetailKonsumsiSiklusTableCompanion(')
          ..write('id: $id, ')
          ..write('idTransaksi: $idTransaksi, ')
          ..write('idSiklus: $idSiklus, ')
          ..write('jumlahDikonsumsi: $jumlahDikonsumsi')
          ..write(')'))
        .toString();
  }
}

class $AntrianDigiflazzTableTable extends AntrianDigiflazzTable
    with TableInfo<$AntrianDigiflazzTableTable, AntrianDigiflazz> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AntrianDigiflazzTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idTransaksiMeta = const VerificationMeta(
    'idTransaksi',
  );
  @override
  late final GeneratedColumn<int> idTransaksi = GeneratedColumn<int>(
    'id_transaksi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transaksi (id)',
    ),
  );
  static const VerificationMeta _kodeProdukMeta = const VerificationMeta(
    'kodeProduk',
  );
  @override
  late final GeneratedColumn<String> kodeProduk = GeneratedColumn<String>(
    'kode_produk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tujuanMeta = const VerificationMeta('tujuan');
  @override
  late final GeneratedColumn<String> tujuan = GeneratedColumn<String>(
    'tujuan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusKirimMeta = const VerificationMeta(
    'statusKirim',
  );
  @override
  late final GeneratedColumn<String> statusKirim = GeneratedColumn<String>(
    'status_kirim',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _responseApiMeta = const VerificationMeta(
    'responseApi',
  );
  @override
  late final GeneratedColumn<String> responseApi = GeneratedColumn<String>(
    'response_api',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idTransaksi,
    kodeProduk,
    tujuan,
    refId,
    statusKirim,
    responseApi,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'antrian_digiflazz';
  @override
  VerificationContext validateIntegrity(
    Insertable<AntrianDigiflazz> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_transaksi')) {
      context.handle(
        _idTransaksiMeta,
        idTransaksi.isAcceptableOrUnknown(
          data['id_transaksi']!,
          _idTransaksiMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idTransaksiMeta);
    }
    if (data.containsKey('kode_produk')) {
      context.handle(
        _kodeProdukMeta,
        kodeProduk.isAcceptableOrUnknown(data['kode_produk']!, _kodeProdukMeta),
      );
    } else if (isInserting) {
      context.missing(_kodeProdukMeta);
    }
    if (data.containsKey('tujuan')) {
      context.handle(
        _tujuanMeta,
        tujuan.isAcceptableOrUnknown(data['tujuan']!, _tujuanMeta),
      );
    } else if (isInserting) {
      context.missing(_tujuanMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    } else if (isInserting) {
      context.missing(_refIdMeta);
    }
    if (data.containsKey('status_kirim')) {
      context.handle(
        _statusKirimMeta,
        statusKirim.isAcceptableOrUnknown(
          data['status_kirim']!,
          _statusKirimMeta,
        ),
      );
    }
    if (data.containsKey('response_api')) {
      context.handle(
        _responseApiMeta,
        responseApi.isAcceptableOrUnknown(
          data['response_api']!,
          _responseApiMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AntrianDigiflazz map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AntrianDigiflazz(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idTransaksi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_transaksi'],
      )!,
      kodeProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kode_produk'],
      )!,
      tujuan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tujuan'],
      )!,
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_id'],
      )!,
      statusKirim: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status_kirim'],
      )!,
      responseApi: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}response_api'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AntrianDigiflazzTableTable createAlias(String alias) {
    return $AntrianDigiflazzTableTable(attachedDatabase, alias);
  }
}

class AntrianDigiflazz extends DataClass
    implements Insertable<AntrianDigiflazz> {
  /// ID auto-increment
  final int id;

  /// FK ke transaksi lokal
  final int idTransaksi;

  /// Kode produk Digiflazz (buyer_sku_code)
  final String kodeProduk;

  /// Nomor tujuan pengisian
  final String tujuan;

  /// Reference ID unik untuk Digiflazz (UUID)
  final String refId;

  /// Status pengiriman: 'pending', 'sukses', 'gagal'
  final String statusKirim;

  /// Response JSON mentah dari API Digiflazz (opsional)
  final String responseApi;

  /// Waktu antrian dibuat
  final DateTime createdAt;
  const AntrianDigiflazz({
    required this.id,
    required this.idTransaksi,
    required this.kodeProduk,
    required this.tujuan,
    required this.refId,
    required this.statusKirim,
    required this.responseApi,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_transaksi'] = Variable<int>(idTransaksi);
    map['kode_produk'] = Variable<String>(kodeProduk);
    map['tujuan'] = Variable<String>(tujuan);
    map['ref_id'] = Variable<String>(refId);
    map['status_kirim'] = Variable<String>(statusKirim);
    map['response_api'] = Variable<String>(responseApi);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AntrianDigiflazzTableCompanion toCompanion(bool nullToAbsent) {
    return AntrianDigiflazzTableCompanion(
      id: Value(id),
      idTransaksi: Value(idTransaksi),
      kodeProduk: Value(kodeProduk),
      tujuan: Value(tujuan),
      refId: Value(refId),
      statusKirim: Value(statusKirim),
      responseApi: Value(responseApi),
      createdAt: Value(createdAt),
    );
  }

  factory AntrianDigiflazz.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AntrianDigiflazz(
      id: serializer.fromJson<int>(json['id']),
      idTransaksi: serializer.fromJson<int>(json['idTransaksi']),
      kodeProduk: serializer.fromJson<String>(json['kodeProduk']),
      tujuan: serializer.fromJson<String>(json['tujuan']),
      refId: serializer.fromJson<String>(json['refId']),
      statusKirim: serializer.fromJson<String>(json['statusKirim']),
      responseApi: serializer.fromJson<String>(json['responseApi']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idTransaksi': serializer.toJson<int>(idTransaksi),
      'kodeProduk': serializer.toJson<String>(kodeProduk),
      'tujuan': serializer.toJson<String>(tujuan),
      'refId': serializer.toJson<String>(refId),
      'statusKirim': serializer.toJson<String>(statusKirim),
      'responseApi': serializer.toJson<String>(responseApi),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AntrianDigiflazz copyWith({
    int? id,
    int? idTransaksi,
    String? kodeProduk,
    String? tujuan,
    String? refId,
    String? statusKirim,
    String? responseApi,
    DateTime? createdAt,
  }) => AntrianDigiflazz(
    id: id ?? this.id,
    idTransaksi: idTransaksi ?? this.idTransaksi,
    kodeProduk: kodeProduk ?? this.kodeProduk,
    tujuan: tujuan ?? this.tujuan,
    refId: refId ?? this.refId,
    statusKirim: statusKirim ?? this.statusKirim,
    responseApi: responseApi ?? this.responseApi,
    createdAt: createdAt ?? this.createdAt,
  );
  AntrianDigiflazz copyWithCompanion(AntrianDigiflazzTableCompanion data) {
    return AntrianDigiflazz(
      id: data.id.present ? data.id.value : this.id,
      idTransaksi: data.idTransaksi.present
          ? data.idTransaksi.value
          : this.idTransaksi,
      kodeProduk: data.kodeProduk.present
          ? data.kodeProduk.value
          : this.kodeProduk,
      tujuan: data.tujuan.present ? data.tujuan.value : this.tujuan,
      refId: data.refId.present ? data.refId.value : this.refId,
      statusKirim: data.statusKirim.present
          ? data.statusKirim.value
          : this.statusKirim,
      responseApi: data.responseApi.present
          ? data.responseApi.value
          : this.responseApi,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AntrianDigiflazz(')
          ..write('id: $id, ')
          ..write('idTransaksi: $idTransaksi, ')
          ..write('kodeProduk: $kodeProduk, ')
          ..write('tujuan: $tujuan, ')
          ..write('refId: $refId, ')
          ..write('statusKirim: $statusKirim, ')
          ..write('responseApi: $responseApi, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idTransaksi,
    kodeProduk,
    tujuan,
    refId,
    statusKirim,
    responseApi,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AntrianDigiflazz &&
          other.id == this.id &&
          other.idTransaksi == this.idTransaksi &&
          other.kodeProduk == this.kodeProduk &&
          other.tujuan == this.tujuan &&
          other.refId == this.refId &&
          other.statusKirim == this.statusKirim &&
          other.responseApi == this.responseApi &&
          other.createdAt == this.createdAt);
}

class AntrianDigiflazzTableCompanion extends UpdateCompanion<AntrianDigiflazz> {
  final Value<int> id;
  final Value<int> idTransaksi;
  final Value<String> kodeProduk;
  final Value<String> tujuan;
  final Value<String> refId;
  final Value<String> statusKirim;
  final Value<String> responseApi;
  final Value<DateTime> createdAt;
  const AntrianDigiflazzTableCompanion({
    this.id = const Value.absent(),
    this.idTransaksi = const Value.absent(),
    this.kodeProduk = const Value.absent(),
    this.tujuan = const Value.absent(),
    this.refId = const Value.absent(),
    this.statusKirim = const Value.absent(),
    this.responseApi = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AntrianDigiflazzTableCompanion.insert({
    this.id = const Value.absent(),
    required int idTransaksi,
    required String kodeProduk,
    required String tujuan,
    required String refId,
    this.statusKirim = const Value.absent(),
    this.responseApi = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : idTransaksi = Value(idTransaksi),
       kodeProduk = Value(kodeProduk),
       tujuan = Value(tujuan),
       refId = Value(refId);
  static Insertable<AntrianDigiflazz> custom({
    Expression<int>? id,
    Expression<int>? idTransaksi,
    Expression<String>? kodeProduk,
    Expression<String>? tujuan,
    Expression<String>? refId,
    Expression<String>? statusKirim,
    Expression<String>? responseApi,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idTransaksi != null) 'id_transaksi': idTransaksi,
      if (kodeProduk != null) 'kode_produk': kodeProduk,
      if (tujuan != null) 'tujuan': tujuan,
      if (refId != null) 'ref_id': refId,
      if (statusKirim != null) 'status_kirim': statusKirim,
      if (responseApi != null) 'response_api': responseApi,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AntrianDigiflazzTableCompanion copyWith({
    Value<int>? id,
    Value<int>? idTransaksi,
    Value<String>? kodeProduk,
    Value<String>? tujuan,
    Value<String>? refId,
    Value<String>? statusKirim,
    Value<String>? responseApi,
    Value<DateTime>? createdAt,
  }) {
    return AntrianDigiflazzTableCompanion(
      id: id ?? this.id,
      idTransaksi: idTransaksi ?? this.idTransaksi,
      kodeProduk: kodeProduk ?? this.kodeProduk,
      tujuan: tujuan ?? this.tujuan,
      refId: refId ?? this.refId,
      statusKirim: statusKirim ?? this.statusKirim,
      responseApi: responseApi ?? this.responseApi,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idTransaksi.present) {
      map['id_transaksi'] = Variable<int>(idTransaksi.value);
    }
    if (kodeProduk.present) {
      map['kode_produk'] = Variable<String>(kodeProduk.value);
    }
    if (tujuan.present) {
      map['tujuan'] = Variable<String>(tujuan.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (statusKirim.present) {
      map['status_kirim'] = Variable<String>(statusKirim.value);
    }
    if (responseApi.present) {
      map['response_api'] = Variable<String>(responseApi.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AntrianDigiflazzTableCompanion(')
          ..write('id: $id, ')
          ..write('idTransaksi: $idTransaksi, ')
          ..write('kodeProduk: $kodeProduk, ')
          ..write('tujuan: $tujuan, ')
          ..write('refId: $refId, ')
          ..write('statusKirim: $statusKirim, ')
          ..write('responseApi: $responseApi, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SiklusTableTable siklusTable = $SiklusTableTable(this);
  late final $ProdukTableTable produkTable = $ProdukTableTable(this);
  late final $PelangganTableTable pelangganTable = $PelangganTableTable(this);
  late final $TransaksiTableTable transaksiTable = $TransaksiTableTable(this);
  late final $DetailKonsumsiSiklusTableTable detailKonsumsiSiklusTable =
      $DetailKonsumsiSiklusTableTable(this);
  late final $AntrianDigiflazzTableTable antrianDigiflazzTable =
      $AntrianDigiflazzTableTable(this);
  late final SiklusDao siklusDao = SiklusDao(this as AppDatabase);
  late final ProdukDao produkDao = ProdukDao(this as AppDatabase);
  late final PelangganDao pelangganDao = PelangganDao(this as AppDatabase);
  late final TransaksiDao transaksiDao = TransaksiDao(this as AppDatabase);
  late final DetailKonsumsiDao detailKonsumsiDao = DetailKonsumsiDao(
    this as AppDatabase,
  );
  late final AntrianDao antrianDao = AntrianDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    siklusTable,
    produkTable,
    pelangganTable,
    transaksiTable,
    detailKonsumsiSiklusTable,
    antrianDigiflazzTable,
  ];
}

typedef $$SiklusTableTableCreateCompanionBuilder =
    SiklusTableCompanion Function({
      Value<int> id,
      required String namaSiklus,
      required int modalSetor,
      Value<int> biayaAdmin,
      Value<int> biayaTransaksi,
      required int saldoMasuk,
      required int saldoSisa,
      Value<DateTime> tanggalMulai,
      Value<DateTime?> tanggalSelesai,
      Value<String> status,
    });
typedef $$SiklusTableTableUpdateCompanionBuilder =
    SiklusTableCompanion Function({
      Value<int> id,
      Value<String> namaSiklus,
      Value<int> modalSetor,
      Value<int> biayaAdmin,
      Value<int> biayaTransaksi,
      Value<int> saldoMasuk,
      Value<int> saldoSisa,
      Value<DateTime> tanggalMulai,
      Value<DateTime?> tanggalSelesai,
      Value<String> status,
    });

final class $$SiklusTableTableReferences
    extends BaseReferences<_$AppDatabase, $SiklusTableTable, Siklus> {
  $$SiklusTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $DetailKonsumsiSiklusTableTable,
    List<DetailKonsumsiSiklus>
  >
  _detailKonsumsiSiklusTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.detailKonsumsiSiklusTable,
        aliasName: $_aliasNameGenerator(
          db.siklusTable.id,
          db.detailKonsumsiSiklusTable.idSiklus,
        ),
      );

  $$DetailKonsumsiSiklusTableTableProcessedTableManager
  get detailKonsumsiSiklusTableRefs {
    final manager = $$DetailKonsumsiSiklusTableTableTableManager(
      $_db,
      $_db.detailKonsumsiSiklusTable,
    ).filter((f) => f.idSiklus.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _detailKonsumsiSiklusTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SiklusTableTableFilterComposer
    extends Composer<_$AppDatabase, $SiklusTableTable> {
  $$SiklusTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaSiklus => $composableBuilder(
    column: $table.namaSiklus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get modalSetor => $composableBuilder(
    column: $table.modalSetor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get biayaAdmin => $composableBuilder(
    column: $table.biayaAdmin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get biayaTransaksi => $composableBuilder(
    column: $table.biayaTransaksi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saldoMasuk => $composableBuilder(
    column: $table.saldoMasuk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saldoSisa => $composableBuilder(
    column: $table.saldoSisa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggalMulai => $composableBuilder(
    column: $table.tanggalMulai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggalSelesai => $composableBuilder(
    column: $table.tanggalSelesai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> detailKonsumsiSiklusTableRefs(
    Expression<bool> Function($$DetailKonsumsiSiklusTableTableFilterComposer f)
    f,
  ) {
    final $$DetailKonsumsiSiklusTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.detailKonsumsiSiklusTable,
          getReferencedColumn: (t) => t.idSiklus,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DetailKonsumsiSiklusTableTableFilterComposer(
                $db: $db,
                $table: $db.detailKonsumsiSiklusTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SiklusTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SiklusTableTable> {
  $$SiklusTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaSiklus => $composableBuilder(
    column: $table.namaSiklus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get modalSetor => $composableBuilder(
    column: $table.modalSetor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get biayaAdmin => $composableBuilder(
    column: $table.biayaAdmin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get biayaTransaksi => $composableBuilder(
    column: $table.biayaTransaksi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saldoMasuk => $composableBuilder(
    column: $table.saldoMasuk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saldoSisa => $composableBuilder(
    column: $table.saldoSisa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggalMulai => $composableBuilder(
    column: $table.tanggalMulai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggalSelesai => $composableBuilder(
    column: $table.tanggalSelesai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SiklusTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SiklusTableTable> {
  $$SiklusTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get namaSiklus => $composableBuilder(
    column: $table.namaSiklus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get modalSetor => $composableBuilder(
    column: $table.modalSetor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get biayaAdmin => $composableBuilder(
    column: $table.biayaAdmin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get biayaTransaksi => $composableBuilder(
    column: $table.biayaTransaksi,
    builder: (column) => column,
  );

  GeneratedColumn<int> get saldoMasuk => $composableBuilder(
    column: $table.saldoMasuk,
    builder: (column) => column,
  );

  GeneratedColumn<int> get saldoSisa =>
      $composableBuilder(column: $table.saldoSisa, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggalMulai => $composableBuilder(
    column: $table.tanggalMulai,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tanggalSelesai => $composableBuilder(
    column: $table.tanggalSelesai,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  Expression<T> detailKonsumsiSiklusTableRefs<T extends Object>(
    Expression<T> Function($$DetailKonsumsiSiklusTableTableAnnotationComposer a)
    f,
  ) {
    final $$DetailKonsumsiSiklusTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.detailKonsumsiSiklusTable,
          getReferencedColumn: (t) => t.idSiklus,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DetailKonsumsiSiklusTableTableAnnotationComposer(
                $db: $db,
                $table: $db.detailKonsumsiSiklusTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SiklusTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SiklusTableTable,
          Siklus,
          $$SiklusTableTableFilterComposer,
          $$SiklusTableTableOrderingComposer,
          $$SiklusTableTableAnnotationComposer,
          $$SiklusTableTableCreateCompanionBuilder,
          $$SiklusTableTableUpdateCompanionBuilder,
          (Siklus, $$SiklusTableTableReferences),
          Siklus,
          PrefetchHooks Function({bool detailKonsumsiSiklusTableRefs})
        > {
  $$SiklusTableTableTableManager(_$AppDatabase db, $SiklusTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SiklusTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SiklusTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SiklusTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> namaSiklus = const Value.absent(),
                Value<int> modalSetor = const Value.absent(),
                Value<int> biayaAdmin = const Value.absent(),
                Value<int> biayaTransaksi = const Value.absent(),
                Value<int> saldoMasuk = const Value.absent(),
                Value<int> saldoSisa = const Value.absent(),
                Value<DateTime> tanggalMulai = const Value.absent(),
                Value<DateTime?> tanggalSelesai = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => SiklusTableCompanion(
                id: id,
                namaSiklus: namaSiklus,
                modalSetor: modalSetor,
                biayaAdmin: biayaAdmin,
                biayaTransaksi: biayaTransaksi,
                saldoMasuk: saldoMasuk,
                saldoSisa: saldoSisa,
                tanggalMulai: tanggalMulai,
                tanggalSelesai: tanggalSelesai,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String namaSiklus,
                required int modalSetor,
                Value<int> biayaAdmin = const Value.absent(),
                Value<int> biayaTransaksi = const Value.absent(),
                required int saldoMasuk,
                required int saldoSisa,
                Value<DateTime> tanggalMulai = const Value.absent(),
                Value<DateTime?> tanggalSelesai = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => SiklusTableCompanion.insert(
                id: id,
                namaSiklus: namaSiklus,
                modalSetor: modalSetor,
                biayaAdmin: biayaAdmin,
                biayaTransaksi: biayaTransaksi,
                saldoMasuk: saldoMasuk,
                saldoSisa: saldoSisa,
                tanggalMulai: tanggalMulai,
                tanggalSelesai: tanggalSelesai,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SiklusTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({detailKonsumsiSiklusTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (detailKonsumsiSiklusTableRefs) db.detailKonsumsiSiklusTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (detailKonsumsiSiklusTableRefs)
                    await $_getPrefetchedData<
                      Siklus,
                      $SiklusTableTable,
                      DetailKonsumsiSiklus
                    >(
                      currentTable: table,
                      referencedTable: $$SiklusTableTableReferences
                          ._detailKonsumsiSiklusTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SiklusTableTableReferences(
                            db,
                            table,
                            p0,
                          ).detailKonsumsiSiklusTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.idSiklus == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SiklusTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SiklusTableTable,
      Siklus,
      $$SiklusTableTableFilterComposer,
      $$SiklusTableTableOrderingComposer,
      $$SiklusTableTableAnnotationComposer,
      $$SiklusTableTableCreateCompanionBuilder,
      $$SiklusTableTableUpdateCompanionBuilder,
      (Siklus, $$SiklusTableTableReferences),
      Siklus,
      PrefetchHooks Function({bool detailKonsumsiSiklusTableRefs})
    >;
typedef $$ProdukTableTableCreateCompanionBuilder =
    ProdukTableCompanion Function({
      Value<int> id,
      required String kodeDigiflazz,
      required String nama,
      Value<String> kategori,
      Value<String> brand,
      required int hargaBeli,
      Value<int> hargaJual,
      Value<bool> aktif,
      Value<String> deskripsi,
      Value<DateTime> lastUpdated,
    });
typedef $$ProdukTableTableUpdateCompanionBuilder =
    ProdukTableCompanion Function({
      Value<int> id,
      Value<String> kodeDigiflazz,
      Value<String> nama,
      Value<String> kategori,
      Value<String> brand,
      Value<int> hargaBeli,
      Value<int> hargaJual,
      Value<bool> aktif,
      Value<String> deskripsi,
      Value<DateTime> lastUpdated,
    });

final class $$ProdukTableTableReferences
    extends BaseReferences<_$AppDatabase, $ProdukTableTable, Produk> {
  $$ProdukTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransaksiTableTable, List<Transaksi>>
  _transaksiTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transaksiTable,
    aliasName: $_aliasNameGenerator(
      db.produkTable.id,
      db.transaksiTable.idProduk,
    ),
  );

  $$TransaksiTableTableProcessedTableManager get transaksiTableRefs {
    final manager = $$TransaksiTableTableTableManager(
      $_db,
      $_db.transaksiTable,
    ).filter((f) => f.idProduk.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transaksiTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProdukTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProdukTableTable> {
  $$ProdukTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kodeDigiflazz => $composableBuilder(
    column: $table.kodeDigiflazz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kategori => $composableBuilder(
    column: $table.kategori,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hargaBeli => $composableBuilder(
    column: $table.hargaBeli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hargaJual => $composableBuilder(
    column: $table.hargaJual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aktif => $composableBuilder(
    column: $table.aktif,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deskripsi => $composableBuilder(
    column: $table.deskripsi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transaksiTableRefs(
    Expression<bool> Function($$TransaksiTableTableFilterComposer f) f,
  ) {
    final $$TransaksiTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transaksiTable,
      getReferencedColumn: (t) => t.idProduk,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableTableFilterComposer(
            $db: $db,
            $table: $db.transaksiTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProdukTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProdukTableTable> {
  $$ProdukTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kodeDigiflazz => $composableBuilder(
    column: $table.kodeDigiflazz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kategori => $composableBuilder(
    column: $table.kategori,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hargaBeli => $composableBuilder(
    column: $table.hargaBeli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hargaJual => $composableBuilder(
    column: $table.hargaJual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aktif => $composableBuilder(
    column: $table.aktif,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deskripsi => $composableBuilder(
    column: $table.deskripsi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProdukTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProdukTableTable> {
  $$ProdukTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kodeDigiflazz => $composableBuilder(
    column: $table.kodeDigiflazz,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get kategori =>
      $composableBuilder(column: $table.kategori, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<int> get hargaBeli =>
      $composableBuilder(column: $table.hargaBeli, builder: (column) => column);

  GeneratedColumn<int> get hargaJual =>
      $composableBuilder(column: $table.hargaJual, builder: (column) => column);

  GeneratedColumn<bool> get aktif =>
      $composableBuilder(column: $table.aktif, builder: (column) => column);

  GeneratedColumn<String> get deskripsi =>
      $composableBuilder(column: $table.deskripsi, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  Expression<T> transaksiTableRefs<T extends Object>(
    Expression<T> Function($$TransaksiTableTableAnnotationComposer a) f,
  ) {
    final $$TransaksiTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transaksiTable,
      getReferencedColumn: (t) => t.idProduk,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableTableAnnotationComposer(
            $db: $db,
            $table: $db.transaksiTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProdukTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProdukTableTable,
          Produk,
          $$ProdukTableTableFilterComposer,
          $$ProdukTableTableOrderingComposer,
          $$ProdukTableTableAnnotationComposer,
          $$ProdukTableTableCreateCompanionBuilder,
          $$ProdukTableTableUpdateCompanionBuilder,
          (Produk, $$ProdukTableTableReferences),
          Produk,
          PrefetchHooks Function({bool transaksiTableRefs})
        > {
  $$ProdukTableTableTableManager(_$AppDatabase db, $ProdukTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProdukTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProdukTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProdukTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kodeDigiflazz = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String> kategori = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<int> hargaBeli = const Value.absent(),
                Value<int> hargaJual = const Value.absent(),
                Value<bool> aktif = const Value.absent(),
                Value<String> deskripsi = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
              }) => ProdukTableCompanion(
                id: id,
                kodeDigiflazz: kodeDigiflazz,
                nama: nama,
                kategori: kategori,
                brand: brand,
                hargaBeli: hargaBeli,
                hargaJual: hargaJual,
                aktif: aktif,
                deskripsi: deskripsi,
                lastUpdated: lastUpdated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kodeDigiflazz,
                required String nama,
                Value<String> kategori = const Value.absent(),
                Value<String> brand = const Value.absent(),
                required int hargaBeli,
                Value<int> hargaJual = const Value.absent(),
                Value<bool> aktif = const Value.absent(),
                Value<String> deskripsi = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
              }) => ProdukTableCompanion.insert(
                id: id,
                kodeDigiflazz: kodeDigiflazz,
                nama: nama,
                kategori: kategori,
                brand: brand,
                hargaBeli: hargaBeli,
                hargaJual: hargaJual,
                aktif: aktif,
                deskripsi: deskripsi,
                lastUpdated: lastUpdated,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProdukTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transaksiTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transaksiTableRefs) db.transaksiTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transaksiTableRefs)
                    await $_getPrefetchedData<
                      Produk,
                      $ProdukTableTable,
                      Transaksi
                    >(
                      currentTable: table,
                      referencedTable: $$ProdukTableTableReferences
                          ._transaksiTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProdukTableTableReferences(
                            db,
                            table,
                            p0,
                          ).transaksiTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.idProduk == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProdukTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProdukTableTable,
      Produk,
      $$ProdukTableTableFilterComposer,
      $$ProdukTableTableOrderingComposer,
      $$ProdukTableTableAnnotationComposer,
      $$ProdukTableTableCreateCompanionBuilder,
      $$ProdukTableTableUpdateCompanionBuilder,
      (Produk, $$ProdukTableTableReferences),
      Produk,
      PrefetchHooks Function({bool transaksiTableRefs})
    >;
typedef $$PelangganTableTableCreateCompanionBuilder =
    PelangganTableCompanion Function({
      Value<int> id,
      required String nama,
      Value<String> noHp,
      Value<String> catatan,
      Value<DateTime> createdAt,
    });
typedef $$PelangganTableTableUpdateCompanionBuilder =
    PelangganTableCompanion Function({
      Value<int> id,
      Value<String> nama,
      Value<String> noHp,
      Value<String> catatan,
      Value<DateTime> createdAt,
    });

final class $$PelangganTableTableReferences
    extends BaseReferences<_$AppDatabase, $PelangganTableTable, Pelanggan> {
  $$PelangganTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TransaksiTableTable, List<Transaksi>>
  _transaksiTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transaksiTable,
    aliasName: $_aliasNameGenerator(
      db.pelangganTable.id,
      db.transaksiTable.idPelanggan,
    ),
  );

  $$TransaksiTableTableProcessedTableManager get transaksiTableRefs {
    final manager = $$TransaksiTableTableTableManager(
      $_db,
      $_db.transaksiTable,
    ).filter((f) => f.idPelanggan.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transaksiTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PelangganTableTableFilterComposer
    extends Composer<_$AppDatabase, $PelangganTableTable> {
  $$PelangganTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noHp => $composableBuilder(
    column: $table.noHp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transaksiTableRefs(
    Expression<bool> Function($$TransaksiTableTableFilterComposer f) f,
  ) {
    final $$TransaksiTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transaksiTable,
      getReferencedColumn: (t) => t.idPelanggan,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableTableFilterComposer(
            $db: $db,
            $table: $db.transaksiTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PelangganTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PelangganTableTable> {
  $$PelangganTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noHp => $composableBuilder(
    column: $table.noHp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PelangganTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PelangganTableTable> {
  $$PelangganTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get noHp =>
      $composableBuilder(column: $table.noHp, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> transaksiTableRefs<T extends Object>(
    Expression<T> Function($$TransaksiTableTableAnnotationComposer a) f,
  ) {
    final $$TransaksiTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transaksiTable,
      getReferencedColumn: (t) => t.idPelanggan,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableTableAnnotationComposer(
            $db: $db,
            $table: $db.transaksiTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PelangganTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PelangganTableTable,
          Pelanggan,
          $$PelangganTableTableFilterComposer,
          $$PelangganTableTableOrderingComposer,
          $$PelangganTableTableAnnotationComposer,
          $$PelangganTableTableCreateCompanionBuilder,
          $$PelangganTableTableUpdateCompanionBuilder,
          (Pelanggan, $$PelangganTableTableReferences),
          Pelanggan,
          PrefetchHooks Function({bool transaksiTableRefs})
        > {
  $$PelangganTableTableTableManager(
    _$AppDatabase db,
    $PelangganTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PelangganTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PelangganTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PelangganTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String> noHp = const Value.absent(),
                Value<String> catatan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PelangganTableCompanion(
                id: id,
                nama: nama,
                noHp: noHp,
                catatan: catatan,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nama,
                Value<String> noHp = const Value.absent(),
                Value<String> catatan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PelangganTableCompanion.insert(
                id: id,
                nama: nama,
                noHp: noHp,
                catatan: catatan,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PelangganTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transaksiTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transaksiTableRefs) db.transaksiTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transaksiTableRefs)
                    await $_getPrefetchedData<
                      Pelanggan,
                      $PelangganTableTable,
                      Transaksi
                    >(
                      currentTable: table,
                      referencedTable: $$PelangganTableTableReferences
                          ._transaksiTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PelangganTableTableReferences(
                            db,
                            table,
                            p0,
                          ).transaksiTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.idPelanggan == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PelangganTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PelangganTableTable,
      Pelanggan,
      $$PelangganTableTableFilterComposer,
      $$PelangganTableTableOrderingComposer,
      $$PelangganTableTableAnnotationComposer,
      $$PelangganTableTableCreateCompanionBuilder,
      $$PelangganTableTableUpdateCompanionBuilder,
      (Pelanggan, $$PelangganTableTableReferences),
      Pelanggan,
      PrefetchHooks Function({bool transaksiTableRefs})
    >;
typedef $$TransaksiTableTableCreateCompanionBuilder =
    TransaksiTableCompanion Function({
      Value<int> id,
      Value<int?> idPelanggan,
      Value<int?> idProduk,
      Value<String> namaProduk,
      required int hargaBeli,
      required int hargaJual,
      required int profit,
      Value<String> statusBayar,
      Value<String> statusKirim,
      Value<String> tujuan,
      Value<String> catatan,
      Value<DateTime> createdAt,
    });
typedef $$TransaksiTableTableUpdateCompanionBuilder =
    TransaksiTableCompanion Function({
      Value<int> id,
      Value<int?> idPelanggan,
      Value<int?> idProduk,
      Value<String> namaProduk,
      Value<int> hargaBeli,
      Value<int> hargaJual,
      Value<int> profit,
      Value<String> statusBayar,
      Value<String> statusKirim,
      Value<String> tujuan,
      Value<String> catatan,
      Value<DateTime> createdAt,
    });

final class $$TransaksiTableTableReferences
    extends BaseReferences<_$AppDatabase, $TransaksiTableTable, Transaksi> {
  $$TransaksiTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PelangganTableTable _idPelangganTable(_$AppDatabase db) =>
      db.pelangganTable.createAlias(
        $_aliasNameGenerator(
          db.transaksiTable.idPelanggan,
          db.pelangganTable.id,
        ),
      );

  $$PelangganTableTableProcessedTableManager? get idPelanggan {
    final $_column = $_itemColumn<int>('id_pelanggan');
    if ($_column == null) return null;
    final manager = $$PelangganTableTableTableManager(
      $_db,
      $_db.pelangganTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idPelangganTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProdukTableTable _idProdukTable(_$AppDatabase db) =>
      db.produkTable.createAlias(
        $_aliasNameGenerator(db.transaksiTable.idProduk, db.produkTable.id),
      );

  $$ProdukTableTableProcessedTableManager? get idProduk {
    final $_column = $_itemColumn<int>('id_produk');
    if ($_column == null) return null;
    final manager = $$ProdukTableTableTableManager(
      $_db,
      $_db.produkTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idProdukTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $DetailKonsumsiSiklusTableTable,
    List<DetailKonsumsiSiklus>
  >
  _detailKonsumsiSiklusTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.detailKonsumsiSiklusTable,
        aliasName: $_aliasNameGenerator(
          db.transaksiTable.id,
          db.detailKonsumsiSiklusTable.idTransaksi,
        ),
      );

  $$DetailKonsumsiSiklusTableTableProcessedTableManager
  get detailKonsumsiSiklusTableRefs {
    final manager = $$DetailKonsumsiSiklusTableTableTableManager(
      $_db,
      $_db.detailKonsumsiSiklusTable,
    ).filter((f) => f.idTransaksi.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _detailKonsumsiSiklusTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AntrianDigiflazzTableTable,
    List<AntrianDigiflazz>
  >
  _antrianDigiflazzTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.antrianDigiflazzTable,
        aliasName: $_aliasNameGenerator(
          db.transaksiTable.id,
          db.antrianDigiflazzTable.idTransaksi,
        ),
      );

  $$AntrianDigiflazzTableTableProcessedTableManager
  get antrianDigiflazzTableRefs {
    final manager = $$AntrianDigiflazzTableTableTableManager(
      $_db,
      $_db.antrianDigiflazzTable,
    ).filter((f) => f.idTransaksi.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _antrianDigiflazzTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransaksiTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransaksiTableTable> {
  $$TransaksiTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hargaBeli => $composableBuilder(
    column: $table.hargaBeli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hargaJual => $composableBuilder(
    column: $table.hargaJual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get profit => $composableBuilder(
    column: $table.profit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusBayar => $composableBuilder(
    column: $table.statusBayar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusKirim => $composableBuilder(
    column: $table.statusKirim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tujuan => $composableBuilder(
    column: $table.tujuan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PelangganTableTableFilterComposer get idPelanggan {
    final $$PelangganTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idPelanggan,
      referencedTable: $db.pelangganTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PelangganTableTableFilterComposer(
            $db: $db,
            $table: $db.pelangganTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProdukTableTableFilterComposer get idProduk {
    final $$ProdukTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProduk,
      referencedTable: $db.produkTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableTableFilterComposer(
            $db: $db,
            $table: $db.produkTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> detailKonsumsiSiklusTableRefs(
    Expression<bool> Function($$DetailKonsumsiSiklusTableTableFilterComposer f)
    f,
  ) {
    final $$DetailKonsumsiSiklusTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.detailKonsumsiSiklusTable,
          getReferencedColumn: (t) => t.idTransaksi,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DetailKonsumsiSiklusTableTableFilterComposer(
                $db: $db,
                $table: $db.detailKonsumsiSiklusTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> antrianDigiflazzTableRefs(
    Expression<bool> Function($$AntrianDigiflazzTableTableFilterComposer f) f,
  ) {
    final $$AntrianDigiflazzTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.antrianDigiflazzTable,
          getReferencedColumn: (t) => t.idTransaksi,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AntrianDigiflazzTableTableFilterComposer(
                $db: $db,
                $table: $db.antrianDigiflazzTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TransaksiTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransaksiTableTable> {
  $$TransaksiTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hargaBeli => $composableBuilder(
    column: $table.hargaBeli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hargaJual => $composableBuilder(
    column: $table.hargaJual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get profit => $composableBuilder(
    column: $table.profit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusBayar => $composableBuilder(
    column: $table.statusBayar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusKirim => $composableBuilder(
    column: $table.statusKirim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tujuan => $composableBuilder(
    column: $table.tujuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PelangganTableTableOrderingComposer get idPelanggan {
    final $$PelangganTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idPelanggan,
      referencedTable: $db.pelangganTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PelangganTableTableOrderingComposer(
            $db: $db,
            $table: $db.pelangganTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProdukTableTableOrderingComposer get idProduk {
    final $$ProdukTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProduk,
      referencedTable: $db.produkTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableTableOrderingComposer(
            $db: $db,
            $table: $db.produkTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransaksiTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransaksiTableTable> {
  $$TransaksiTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hargaBeli =>
      $composableBuilder(column: $table.hargaBeli, builder: (column) => column);

  GeneratedColumn<int> get hargaJual =>
      $composableBuilder(column: $table.hargaJual, builder: (column) => column);

  GeneratedColumn<int> get profit =>
      $composableBuilder(column: $table.profit, builder: (column) => column);

  GeneratedColumn<String> get statusBayar => $composableBuilder(
    column: $table.statusBayar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get statusKirim => $composableBuilder(
    column: $table.statusKirim,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tujuan =>
      $composableBuilder(column: $table.tujuan, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PelangganTableTableAnnotationComposer get idPelanggan {
    final $$PelangganTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idPelanggan,
      referencedTable: $db.pelangganTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PelangganTableTableAnnotationComposer(
            $db: $db,
            $table: $db.pelangganTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProdukTableTableAnnotationComposer get idProduk {
    final $$ProdukTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idProduk,
      referencedTable: $db.produkTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableTableAnnotationComposer(
            $db: $db,
            $table: $db.produkTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> detailKonsumsiSiklusTableRefs<T extends Object>(
    Expression<T> Function($$DetailKonsumsiSiklusTableTableAnnotationComposer a)
    f,
  ) {
    final $$DetailKonsumsiSiklusTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.detailKonsumsiSiklusTable,
          getReferencedColumn: (t) => t.idTransaksi,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DetailKonsumsiSiklusTableTableAnnotationComposer(
                $db: $db,
                $table: $db.detailKonsumsiSiklusTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> antrianDigiflazzTableRefs<T extends Object>(
    Expression<T> Function($$AntrianDigiflazzTableTableAnnotationComposer a) f,
  ) {
    final $$AntrianDigiflazzTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.antrianDigiflazzTable,
          getReferencedColumn: (t) => t.idTransaksi,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AntrianDigiflazzTableTableAnnotationComposer(
                $db: $db,
                $table: $db.antrianDigiflazzTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TransaksiTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransaksiTableTable,
          Transaksi,
          $$TransaksiTableTableFilterComposer,
          $$TransaksiTableTableOrderingComposer,
          $$TransaksiTableTableAnnotationComposer,
          $$TransaksiTableTableCreateCompanionBuilder,
          $$TransaksiTableTableUpdateCompanionBuilder,
          (Transaksi, $$TransaksiTableTableReferences),
          Transaksi,
          PrefetchHooks Function({
            bool idPelanggan,
            bool idProduk,
            bool detailKonsumsiSiklusTableRefs,
            bool antrianDigiflazzTableRefs,
          })
        > {
  $$TransaksiTableTableTableManager(
    _$AppDatabase db,
    $TransaksiTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransaksiTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransaksiTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransaksiTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> idPelanggan = const Value.absent(),
                Value<int?> idProduk = const Value.absent(),
                Value<String> namaProduk = const Value.absent(),
                Value<int> hargaBeli = const Value.absent(),
                Value<int> hargaJual = const Value.absent(),
                Value<int> profit = const Value.absent(),
                Value<String> statusBayar = const Value.absent(),
                Value<String> statusKirim = const Value.absent(),
                Value<String> tujuan = const Value.absent(),
                Value<String> catatan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransaksiTableCompanion(
                id: id,
                idPelanggan: idPelanggan,
                idProduk: idProduk,
                namaProduk: namaProduk,
                hargaBeli: hargaBeli,
                hargaJual: hargaJual,
                profit: profit,
                statusBayar: statusBayar,
                statusKirim: statusKirim,
                tujuan: tujuan,
                catatan: catatan,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> idPelanggan = const Value.absent(),
                Value<int?> idProduk = const Value.absent(),
                Value<String> namaProduk = const Value.absent(),
                required int hargaBeli,
                required int hargaJual,
                required int profit,
                Value<String> statusBayar = const Value.absent(),
                Value<String> statusKirim = const Value.absent(),
                Value<String> tujuan = const Value.absent(),
                Value<String> catatan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransaksiTableCompanion.insert(
                id: id,
                idPelanggan: idPelanggan,
                idProduk: idProduk,
                namaProduk: namaProduk,
                hargaBeli: hargaBeli,
                hargaJual: hargaJual,
                profit: profit,
                statusBayar: statusBayar,
                statusKirim: statusKirim,
                tujuan: tujuan,
                catatan: catatan,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransaksiTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                idPelanggan = false,
                idProduk = false,
                detailKonsumsiSiklusTableRefs = false,
                antrianDigiflazzTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (detailKonsumsiSiklusTableRefs)
                      db.detailKonsumsiSiklusTable,
                    if (antrianDigiflazzTableRefs) db.antrianDigiflazzTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (idPelanggan) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idPelanggan,
                                    referencedTable:
                                        $$TransaksiTableTableReferences
                                            ._idPelangganTable(db),
                                    referencedColumn:
                                        $$TransaksiTableTableReferences
                                            ._idPelangganTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (idProduk) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.idProduk,
                                    referencedTable:
                                        $$TransaksiTableTableReferences
                                            ._idProdukTable(db),
                                    referencedColumn:
                                        $$TransaksiTableTableReferences
                                            ._idProdukTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (detailKonsumsiSiklusTableRefs)
                        await $_getPrefetchedData<
                          Transaksi,
                          $TransaksiTableTable,
                          DetailKonsumsiSiklus
                        >(
                          currentTable: table,
                          referencedTable: $$TransaksiTableTableReferences
                              ._detailKonsumsiSiklusTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransaksiTableTableReferences(
                                db,
                                table,
                                p0,
                              ).detailKonsumsiSiklusTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idTransaksi == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (antrianDigiflazzTableRefs)
                        await $_getPrefetchedData<
                          Transaksi,
                          $TransaksiTableTable,
                          AntrianDigiflazz
                        >(
                          currentTable: table,
                          referencedTable: $$TransaksiTableTableReferences
                              ._antrianDigiflazzTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransaksiTableTableReferences(
                                db,
                                table,
                                p0,
                              ).antrianDigiflazzTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.idTransaksi == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransaksiTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransaksiTableTable,
      Transaksi,
      $$TransaksiTableTableFilterComposer,
      $$TransaksiTableTableOrderingComposer,
      $$TransaksiTableTableAnnotationComposer,
      $$TransaksiTableTableCreateCompanionBuilder,
      $$TransaksiTableTableUpdateCompanionBuilder,
      (Transaksi, $$TransaksiTableTableReferences),
      Transaksi,
      PrefetchHooks Function({
        bool idPelanggan,
        bool idProduk,
        bool detailKonsumsiSiklusTableRefs,
        bool antrianDigiflazzTableRefs,
      })
    >;
typedef $$DetailKonsumsiSiklusTableTableCreateCompanionBuilder =
    DetailKonsumsiSiklusTableCompanion Function({
      Value<int> id,
      required int idTransaksi,
      required int idSiklus,
      required int jumlahDikonsumsi,
    });
typedef $$DetailKonsumsiSiklusTableTableUpdateCompanionBuilder =
    DetailKonsumsiSiklusTableCompanion Function({
      Value<int> id,
      Value<int> idTransaksi,
      Value<int> idSiklus,
      Value<int> jumlahDikonsumsi,
    });

final class $$DetailKonsumsiSiklusTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DetailKonsumsiSiklusTableTable,
          DetailKonsumsiSiklus
        > {
  $$DetailKonsumsiSiklusTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransaksiTableTable _idTransaksiTable(_$AppDatabase db) =>
      db.transaksiTable.createAlias(
        $_aliasNameGenerator(
          db.detailKonsumsiSiklusTable.idTransaksi,
          db.transaksiTable.id,
        ),
      );

  $$TransaksiTableTableProcessedTableManager get idTransaksi {
    final $_column = $_itemColumn<int>('id_transaksi')!;

    final manager = $$TransaksiTableTableTableManager(
      $_db,
      $_db.transaksiTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idTransaksiTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SiklusTableTable _idSiklusTable(_$AppDatabase db) =>
      db.siklusTable.createAlias(
        $_aliasNameGenerator(
          db.detailKonsumsiSiklusTable.idSiklus,
          db.siklusTable.id,
        ),
      );

  $$SiklusTableTableProcessedTableManager get idSiklus {
    final $_column = $_itemColumn<int>('id_siklus')!;

    final manager = $$SiklusTableTableTableManager(
      $_db,
      $_db.siklusTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idSiklusTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DetailKonsumsiSiklusTableTableFilterComposer
    extends Composer<_$AppDatabase, $DetailKonsumsiSiklusTableTable> {
  $$DetailKonsumsiSiklusTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jumlahDikonsumsi => $composableBuilder(
    column: $table.jumlahDikonsumsi,
    builder: (column) => ColumnFilters(column),
  );

  $$TransaksiTableTableFilterComposer get idTransaksi {
    final $$TransaksiTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idTransaksi,
      referencedTable: $db.transaksiTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableTableFilterComposer(
            $db: $db,
            $table: $db.transaksiTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SiklusTableTableFilterComposer get idSiklus {
    final $$SiklusTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idSiklus,
      referencedTable: $db.siklusTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiklusTableTableFilterComposer(
            $db: $db,
            $table: $db.siklusTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DetailKonsumsiSiklusTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DetailKonsumsiSiklusTableTable> {
  $$DetailKonsumsiSiklusTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jumlahDikonsumsi => $composableBuilder(
    column: $table.jumlahDikonsumsi,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransaksiTableTableOrderingComposer get idTransaksi {
    final $$TransaksiTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idTransaksi,
      referencedTable: $db.transaksiTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableTableOrderingComposer(
            $db: $db,
            $table: $db.transaksiTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SiklusTableTableOrderingComposer get idSiklus {
    final $$SiklusTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idSiklus,
      referencedTable: $db.siklusTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiklusTableTableOrderingComposer(
            $db: $db,
            $table: $db.siklusTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DetailKonsumsiSiklusTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DetailKonsumsiSiklusTableTable> {
  $$DetailKonsumsiSiklusTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get jumlahDikonsumsi => $composableBuilder(
    column: $table.jumlahDikonsumsi,
    builder: (column) => column,
  );

  $$TransaksiTableTableAnnotationComposer get idTransaksi {
    final $$TransaksiTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idTransaksi,
      referencedTable: $db.transaksiTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableTableAnnotationComposer(
            $db: $db,
            $table: $db.transaksiTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SiklusTableTableAnnotationComposer get idSiklus {
    final $$SiklusTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idSiklus,
      referencedTable: $db.siklusTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SiklusTableTableAnnotationComposer(
            $db: $db,
            $table: $db.siklusTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DetailKonsumsiSiklusTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DetailKonsumsiSiklusTableTable,
          DetailKonsumsiSiklus,
          $$DetailKonsumsiSiklusTableTableFilterComposer,
          $$DetailKonsumsiSiklusTableTableOrderingComposer,
          $$DetailKonsumsiSiklusTableTableAnnotationComposer,
          $$DetailKonsumsiSiklusTableTableCreateCompanionBuilder,
          $$DetailKonsumsiSiklusTableTableUpdateCompanionBuilder,
          (DetailKonsumsiSiklus, $$DetailKonsumsiSiklusTableTableReferences),
          DetailKonsumsiSiklus,
          PrefetchHooks Function({bool idTransaksi, bool idSiklus})
        > {
  $$DetailKonsumsiSiklusTableTableTableManager(
    _$AppDatabase db,
    $DetailKonsumsiSiklusTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DetailKonsumsiSiklusTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DetailKonsumsiSiklusTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DetailKonsumsiSiklusTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idTransaksi = const Value.absent(),
                Value<int> idSiklus = const Value.absent(),
                Value<int> jumlahDikonsumsi = const Value.absent(),
              }) => DetailKonsumsiSiklusTableCompanion(
                id: id,
                idTransaksi: idTransaksi,
                idSiklus: idSiklus,
                jumlahDikonsumsi: jumlahDikonsumsi,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idTransaksi,
                required int idSiklus,
                required int jumlahDikonsumsi,
              }) => DetailKonsumsiSiklusTableCompanion.insert(
                id: id,
                idTransaksi: idTransaksi,
                idSiklus: idSiklus,
                jumlahDikonsumsi: jumlahDikonsumsi,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DetailKonsumsiSiklusTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idTransaksi = false, idSiklus = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idTransaksi) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idTransaksi,
                                referencedTable:
                                    $$DetailKonsumsiSiklusTableTableReferences
                                        ._idTransaksiTable(db),
                                referencedColumn:
                                    $$DetailKonsumsiSiklusTableTableReferences
                                        ._idTransaksiTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (idSiklus) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idSiklus,
                                referencedTable:
                                    $$DetailKonsumsiSiklusTableTableReferences
                                        ._idSiklusTable(db),
                                referencedColumn:
                                    $$DetailKonsumsiSiklusTableTableReferences
                                        ._idSiklusTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DetailKonsumsiSiklusTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DetailKonsumsiSiklusTableTable,
      DetailKonsumsiSiklus,
      $$DetailKonsumsiSiklusTableTableFilterComposer,
      $$DetailKonsumsiSiklusTableTableOrderingComposer,
      $$DetailKonsumsiSiklusTableTableAnnotationComposer,
      $$DetailKonsumsiSiklusTableTableCreateCompanionBuilder,
      $$DetailKonsumsiSiklusTableTableUpdateCompanionBuilder,
      (DetailKonsumsiSiklus, $$DetailKonsumsiSiklusTableTableReferences),
      DetailKonsumsiSiklus,
      PrefetchHooks Function({bool idTransaksi, bool idSiklus})
    >;
typedef $$AntrianDigiflazzTableTableCreateCompanionBuilder =
    AntrianDigiflazzTableCompanion Function({
      Value<int> id,
      required int idTransaksi,
      required String kodeProduk,
      required String tujuan,
      required String refId,
      Value<String> statusKirim,
      Value<String> responseApi,
      Value<DateTime> createdAt,
    });
typedef $$AntrianDigiflazzTableTableUpdateCompanionBuilder =
    AntrianDigiflazzTableCompanion Function({
      Value<int> id,
      Value<int> idTransaksi,
      Value<String> kodeProduk,
      Value<String> tujuan,
      Value<String> refId,
      Value<String> statusKirim,
      Value<String> responseApi,
      Value<DateTime> createdAt,
    });

final class $$AntrianDigiflazzTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AntrianDigiflazzTableTable,
          AntrianDigiflazz
        > {
  $$AntrianDigiflazzTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransaksiTableTable _idTransaksiTable(_$AppDatabase db) =>
      db.transaksiTable.createAlias(
        $_aliasNameGenerator(
          db.antrianDigiflazzTable.idTransaksi,
          db.transaksiTable.id,
        ),
      );

  $$TransaksiTableTableProcessedTableManager get idTransaksi {
    final $_column = $_itemColumn<int>('id_transaksi')!;

    final manager = $$TransaksiTableTableTableManager(
      $_db,
      $_db.transaksiTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_idTransaksiTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AntrianDigiflazzTableTableFilterComposer
    extends Composer<_$AppDatabase, $AntrianDigiflazzTableTable> {
  $$AntrianDigiflazzTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kodeProduk => $composableBuilder(
    column: $table.kodeProduk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tujuan => $composableBuilder(
    column: $table.tujuan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statusKirim => $composableBuilder(
    column: $table.statusKirim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responseApi => $composableBuilder(
    column: $table.responseApi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TransaksiTableTableFilterComposer get idTransaksi {
    final $$TransaksiTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idTransaksi,
      referencedTable: $db.transaksiTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableTableFilterComposer(
            $db: $db,
            $table: $db.transaksiTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AntrianDigiflazzTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AntrianDigiflazzTableTable> {
  $$AntrianDigiflazzTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kodeProduk => $composableBuilder(
    column: $table.kodeProduk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tujuan => $composableBuilder(
    column: $table.tujuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statusKirim => $composableBuilder(
    column: $table.statusKirim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responseApi => $composableBuilder(
    column: $table.responseApi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransaksiTableTableOrderingComposer get idTransaksi {
    final $$TransaksiTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idTransaksi,
      referencedTable: $db.transaksiTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableTableOrderingComposer(
            $db: $db,
            $table: $db.transaksiTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AntrianDigiflazzTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AntrianDigiflazzTableTable> {
  $$AntrianDigiflazzTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kodeProduk => $composableBuilder(
    column: $table.kodeProduk,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tujuan =>
      $composableBuilder(column: $table.tujuan, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<String> get statusKirim => $composableBuilder(
    column: $table.statusKirim,
    builder: (column) => column,
  );

  GeneratedColumn<String> get responseApi => $composableBuilder(
    column: $table.responseApi,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TransaksiTableTableAnnotationComposer get idTransaksi {
    final $$TransaksiTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.idTransaksi,
      referencedTable: $db.transaksiTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableTableAnnotationComposer(
            $db: $db,
            $table: $db.transaksiTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AntrianDigiflazzTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AntrianDigiflazzTableTable,
          AntrianDigiflazz,
          $$AntrianDigiflazzTableTableFilterComposer,
          $$AntrianDigiflazzTableTableOrderingComposer,
          $$AntrianDigiflazzTableTableAnnotationComposer,
          $$AntrianDigiflazzTableTableCreateCompanionBuilder,
          $$AntrianDigiflazzTableTableUpdateCompanionBuilder,
          (AntrianDigiflazz, $$AntrianDigiflazzTableTableReferences),
          AntrianDigiflazz,
          PrefetchHooks Function({bool idTransaksi})
        > {
  $$AntrianDigiflazzTableTableTableManager(
    _$AppDatabase db,
    $AntrianDigiflazzTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AntrianDigiflazzTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AntrianDigiflazzTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AntrianDigiflazzTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> idTransaksi = const Value.absent(),
                Value<String> kodeProduk = const Value.absent(),
                Value<String> tujuan = const Value.absent(),
                Value<String> refId = const Value.absent(),
                Value<String> statusKirim = const Value.absent(),
                Value<String> responseApi = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AntrianDigiflazzTableCompanion(
                id: id,
                idTransaksi: idTransaksi,
                kodeProduk: kodeProduk,
                tujuan: tujuan,
                refId: refId,
                statusKirim: statusKirim,
                responseApi: responseApi,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int idTransaksi,
                required String kodeProduk,
                required String tujuan,
                required String refId,
                Value<String> statusKirim = const Value.absent(),
                Value<String> responseApi = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AntrianDigiflazzTableCompanion.insert(
                id: id,
                idTransaksi: idTransaksi,
                kodeProduk: kodeProduk,
                tujuan: tujuan,
                refId: refId,
                statusKirim: statusKirim,
                responseApi: responseApi,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AntrianDigiflazzTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({idTransaksi = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (idTransaksi) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.idTransaksi,
                                referencedTable:
                                    $$AntrianDigiflazzTableTableReferences
                                        ._idTransaksiTable(db),
                                referencedColumn:
                                    $$AntrianDigiflazzTableTableReferences
                                        ._idTransaksiTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AntrianDigiflazzTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AntrianDigiflazzTableTable,
      AntrianDigiflazz,
      $$AntrianDigiflazzTableTableFilterComposer,
      $$AntrianDigiflazzTableTableOrderingComposer,
      $$AntrianDigiflazzTableTableAnnotationComposer,
      $$AntrianDigiflazzTableTableCreateCompanionBuilder,
      $$AntrianDigiflazzTableTableUpdateCompanionBuilder,
      (AntrianDigiflazz, $$AntrianDigiflazzTableTableReferences),
      AntrianDigiflazz,
      PrefetchHooks Function({bool idTransaksi})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SiklusTableTableTableManager get siklusTable =>
      $$SiklusTableTableTableManager(_db, _db.siklusTable);
  $$ProdukTableTableTableManager get produkTable =>
      $$ProdukTableTableTableManager(_db, _db.produkTable);
  $$PelangganTableTableTableManager get pelangganTable =>
      $$PelangganTableTableTableManager(_db, _db.pelangganTable);
  $$TransaksiTableTableTableManager get transaksiTable =>
      $$TransaksiTableTableTableManager(_db, _db.transaksiTable);
  $$DetailKonsumsiSiklusTableTableTableManager get detailKonsumsiSiklusTable =>
      $$DetailKonsumsiSiklusTableTableTableManager(
        _db,
        _db.detailKonsumsiSiklusTable,
      );
  $$AntrianDigiflazzTableTableTableManager get antrianDigiflazzTable =>
      $$AntrianDigiflazzTableTableTableManager(_db, _db.antrianDigiflazzTable);
}
